// To avoid deployment errors, do not call admin.initializeApp() in your code

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const db = admin.firestore();

// Mensajes de respuesta estándar

const SUCCESS_MESSAGE = { message: "Webhook recibido y procesando en segundo plano" };
const INVALID_REQUEST_MESSAGE = { error: "Solicitud inválida. El cuerpo de la solicitud no válido" };

const CONFIG = {
    collections: {
        webhookRecibidosMercadoLibre: {
            collectionName: 'webhookRecibidosMercadoLibre',
            docIdKey: 'idWML',
            mode: 'production',
        }
    },
};

async function saveToFirestore(collectionKey, data) {
    const { collectionName, docIdKey, mode } = CONFIG.collections[collectionKey];
    try {
        if (mode === 'production' && data[docIdKey]) {
            const docRef = db.collection(collectionName).doc(data[docIdKey]);
            const doc = await docRef.get();
            if (!doc.exists) {
                await docRef.set(data);
                console.log(`Webhook almacenado en ${collectionName} con Doc ID: ${data[docIdKey]} (producción)`);
            } else {
                console.log(`Webhook ya existe en ${collectionName}, Doc ID: ${data[docIdKey]} (producción)`);
            }
        } else {
            await db.collection(collectionName).add(data);
            console.log(`Webhook almacenado en ${collectionName} con ID automático (${mode})`);
        }
    } catch (error) {
        console.error(`Error al guardar webhook en ${collectionName}:`, error);
    }
}

async function handleMercadoLibreWebhook(body) {
    const dataToSave = {
        idWML: body._id || null,
        resource: body.resource || null,
        user_id: body.user_id || null,
        topic: body.topic || null,
        application_id: body.application_id || null,
        attempts: body.attempts || 0,
        sent: body.sent ? new Date(body.sent) : null,
        received: body.received ? new Date(body.received) : null,
        fechaHoraRecepcionEnFuncion: admin.firestore.FieldValue.serverTimestamp(),
    };

    await saveToFirestore('webhookRecibidosMercadoLibre', dataToSave);
}

// ✅ Validación mínima del body
function isValidMercadoLibreWebhook(body) {
    return (
        typeof body === 'object' &&
        typeof body._id === 'string' &&
        typeof body.resource === 'string' &&
        typeof body.user_id === 'number' &&
        typeof body.application_id === 'number'
    );
}

exports.webhookreceivermercadolibre = functions
    .runWith({
        timeoutSeconds: 540,
        memory: '1GB'
    })
    .https.onRequest(async (req, res) => {
        // Enviar respuesta exitosa inmediatamente para evitar timeouts
        res.status(200).send(SUCCESS_MESSAGE);

        const body = req.body;
        // ✅ Registro del cuerpo completo del webhook en una sola línea
        console.log(`Webhook body: ${JSON.stringify(body)}`);

        try {
            // 🚨 Registro inicial y validación del cuerpo de la solicitud
            if (!body || Object.keys(body).length === 0) {
                console.error("Webhook inválido: El cuerpo de la solicitud está vacío.");
                return;
            }

            // 🚨 Validación de contenido de Mercado Libre
            if (!isValidMercadoLibreWebhook(body)) {
                // Registro del webhook inválido para trazabilidad
                console.error(`Webhook inválido. Los datos no corresponden al formato esperado. Body recibido:`, JSON.stringify(body, null, 2));
                return;
            }

            // ✅ Extracción de campos clave y registro detallado
            const { _id, resource, topic, user_id, application_id } = body;
            const logPrefix = `[Webhook ID: ${_id}] [Topic: ${topic}] [Resource: ${resource}]`;

            console.log(`${logPrefix} Webhook válido recibido para user_id: ${user_id} y application_id: ${application_id}. Procesando...`);

            await handleMercadoLibreWebhook(body);

            console.log(`${logPrefix} Procesamiento completado exitosamente.`);

        } catch (error) {
            // 🚨 Manejo de errores críticos en el procesamiento en segundo plano
            const { _id = 'N/A', topic = 'N/A', resource = 'N/A' } = body || {};
            const logPrefix = `[Webhook ID: ${_id}] [Topic: ${topic}] [Resource: ${resource}]`;
            console.error(`${logPrefix} Error crítico durante el procesamiento del webhook:`, error);
        }
    });
