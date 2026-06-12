//
// ----- DEPENDENCIAS -----
//
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
const db = admin.firestore();

const secretManagerClient = new SecretManagerServiceClient();

// ----- NUEVO: CONFIGURACIÓN DE ENTORNO (Control Manual) -----
// ¡¡¡ATENCIÓN!!! Debes cambiar este valor manualmente antes de desplegar.
// true = usará la colección de Producción ('PedidosBS')
// false = usará la colección de Pruebas ('PedidosBSDevelopment')
const MODO_PRODUCCION = true;

// Se determina el nombre de la colección según el booleano.
const collectionName = MODO_PRODUCCION ? 'PedidosBS' : 'PedidosBSDevelopment';

//
// ----- CONFIGURACIÓN DE SEGURIDAD (SECRET MANAGER) -----
//
async function getBsaleAccessToken() {
  const name = 'projects/pickinglist-523b2/secrets/bsale-api-token/versions/latest';
  try {
    const [version] = await secretManagerClient.accessSecretVersion({ name });
    const accessToken = version.payload.data.toString('utf8');
    return accessToken;
  } catch (error) {
    console.error("Error crítico al acceder al secreto de Bsale:", error);
    throw new Error("No se pudo obtener el token de acceso de Bsale desde Secret Manager.");
  }
}

//
// ----- LÓGICA DE API EXTERNA (BSALE) -----
//
async function fetchApiBsaleCheckout(accessToken, startDate, endDate, limit, offset) {
  // (Esta función no cambia)
  try {
    if (!startDate || !endDate) {
      throw new Error('Los parámetros startDate y endDate son obligatorios');
    }
    const url = 'https://api.bsale.io/v1/markets/checkout/list.json';
    const params = new URLSearchParams({
      dateStart: startDate,
      dateEnd: endDate,
      limit: limit,
      offset: offset,
    });
    const headers = { 'access_token': accessToken };
    const response = await fetch(`${url}?${params.toString()}`, { headers });
    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Error en API Bsale ${response.status}: ${errorText}`);
    }
    return await response.json();
  } catch (error) {
    console.error("Error al obtener datos de la API de Bsale:", error);
    throw error;
  }
}

//
// ----- LÓGICA DE PROCESAMIENTO INDIVIDUAL -----
//
async function checkAndUpdateSingleOrder(pedido, accessToken) {
  try {
    const documentNumber = parseInt(pedido.IDdocument.toString().trim(), 10);
    const fechaGeneracion = pedido.GenerationDate;
    const fechaEmision = (Number(pedido.EmisionDate) - 86400).toString();

    const initialResponse = await fetchApiBsaleCheckout(accessToken, fechaEmision, fechaGeneracion, 50, 0);

    if (!initialResponse || !initialResponse.data) {
      console.warn(`Respuesta incompleta de Bsale para el pedido ${pedido.id}. Saltando.`);
      return;
    }

    let resultadoEncontrado = null;
    const findOrderInData = (data) => {
      const mapaPedidos = data.reduce((mapa, dato) => {
        const idNormalizado = parseInt(dato.id_venta_documento_tributario, 10);
        mapa[idNormalizado] = dato;
        return mapa;
      }, {});
      return mapaPedidos[documentNumber] || null;
    };
    resultadoEncontrado = findOrderInData(initialResponse.data);

    if (!resultadoEncontrado && initialResponse.count > initialResponse.data.length) {
      const limite = 50;
      const iteraciones = Math.ceil(initialResponse.count / limite);
      for (let i = 1; i < iteraciones; i++) {
        const offset = i * limite;
        try {
          const apiResponsePage = await fetchApiBsaleCheckout(accessToken, fechaEmision, fechaGeneracion, limite, offset);
          if (apiResponsePage && apiResponsePage.data) {
            resultadoEncontrado = findOrderInData(apiResponsePage.data);
            if (resultadoEncontrado) {
              break;
            }
          }
        } catch (offsetError) {
          console.error(`Error obteniendo la página con offset ${offset} para el pedido ${pedido.id}:`, offsetError.message);
        }
      }
    }
    
    if (resultadoEncontrado) {
      const estatusDePago = resultadoEncontrado.payProcess;
      // Se usa la variable 'collectionName' para la actualización.
      await db.collection(collectionName).doc(pedido.id).update({
        estatus_pago: estatusDePago,
      });
      console.log(`Pedido ${pedido.id} en [${collectionName}] actualizado con estatus de pago: ${estatusDePago}`);
    } else {
      console.log(`No se encontró el pedido ${pedido.id} (Doc: ${documentNumber}) en la API de Bsale.`);
    }

  } catch (pedidoError) {
    console.error(`Fallo total al procesar el pedido ${pedido.id}:`, pedidoError.message);
  }
}

//
// ----- CLOUD FUNCTION PRINCIPAL -----
//
exports.verificacionPedidosPending = functions
  .runWith({ timeoutSeconds: 540, memory: '256MB' })
  .https.onRequest(async (req, res) => {
    console.log(`Iniciando verificación en la colección: [${collectionName}].`);

    try {
      if (req.method !== "GET") {
        return res.status(405).send("Método no permitido. Usa GET.");
      }
      const BSALE_ACCESS_TOKEN = await getBsaleAccessToken();
      
      // Se usa la variable 'collectionName' para la consulta.
      const pedidosRef = db.collection(collectionName);
      const snapshot = await pedidosRef.where("estatus_pago", "==", "pending").get();

      if (snapshot.empty) {
        console.log("No se encontraron pedidos con estatus_pago 'pending'.");
        return res.status(200).json({ mensaje: "No hay pedidos pendientes para verificar." });
      }

      const pedidos = [];
      snapshot.forEach((doc) => {
        pedidos.push({ id: doc.id, ...doc.data() });
      });

      const processingPromises = pedidos.map(pedido => checkAndUpdateSingleOrder(pedido, BSALE_ACCESS_TOKEN));
      await Promise.all(processingPromises);
      
      console.log(`Proceso completado. Se verificaron ${pedidos.length} pedidos en [${collectionName}].`);
      return res.status(200).json({
        mensaje: `Verificación completada en [${collectionName}].`,
        cantidad_verificada: pedidos.length,
      });

    } catch (error) {
      console.error(`Error crítico durante la ejecución en [${collectionName}]:`, error);
      return res.status(500).json({
        mensaje: "Ocurrió un error general al procesar la solicitud.",
        error: error.message,
      });
    }
  });
