**
 * @fileoverview Cloud Function para manejar el callback de OAuth2 de Mercado Libre.
 * @author Asistente de Google
 * @version 2.0.0
 *
 * @history
 * - 1.1.0: Versión inicial con 'fetch' nativo y variables de entorno.
 * - 2.0.0 (15-06-2025): Se refactoriza para utilizar Google Secret Manager en lugar de variables
 * de entorno, mejorando la seguridad y la gestión de credenciales.
 */

// Importaciones de módulos necesarios
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// --- CONFIGURACIÓN DE SECRET MANAGER ---
// Importa el cliente oficial de Google para Secret Manager.
const { SecretManagerServiceClient } = require('@google-cloud/secret-manager');
// Crea una instancia del cliente que se reutilizará en las invocaciones de la función.
const secretManagerClient = new SecretManagerServiceClient();
// Obtiene el ID del proyecto de Google Cloud automáticamente del entorno de ejecución.
const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT;

/**
 * Función auxiliar para acceder de forma segura a la última versión de un secreto.
 * @param {string} secretName - El nombre del secreto que se quiere obtener.
 * @returns {Promise<string>} El valor del secreto como una cadena de texto.
 */
async function accessSecret(secretName) {
    // Construye el nombre completo del recurso del secreto.
    const name = `projects/${projectId}/secrets/${secretName}/versions/latest`;
    // Llama a la API para acceder a la versión del secreto.
    const [version] = await secretManagerClient.accessSecretVersion({ name });
    // Decodifica y devuelve el contenido del secreto.
    return version.payload.data.toString('utf8');
}

/**
 * Construye un objeto estandarizado con los datos del token recibidos.
 * @param {object} body - La respuesta JSON de la API de Mercado Libre.
 * @returns {object} Un objeto listo para ser guardado en Firestore.
 */
function buildDataObject(body) {
    return {
        access_token: body.access_token || null,
        token_type: body.token_type || null,
        expires_in: body.expires_in || null,
        scope: body.scope || null,
        user_id: body.user_id || null,
        refresh_token: body.refresh_token || null,
        aplicacion: "Mercado Libre",
        fechaHoraDeEjecucion: admin.firestore.FieldValue.serverTimestamp(),
    };
}

exports.oauthmercadolibre = functions.https.onRequest(async (req, res) => {
    // Se procesan únicamente las solicitudes GET, que es como Mercado Libre envía el código.
    if (req.method === "GET") {
        const code = req.query.code;
        if (!code) {
            console.error("No se recibió el código de autorización en la URL.");
            return res.status(400).send({ error: "No se proporcionó el código de autorización" });
        }

        try {
            // Carga las 3 credenciales desde Secret Manager de forma concurrente.
            const [clientId, clientSecret, redirectUri] = await Promise.all([
                accessSecret('CLIENT_ID_MERCADOLIBRE'),
                accessSecret('CLIENT_SECRET_MERCADOLIBRE'),
                accessSecret('REDIRECT_URI_MERCADOLIBRE')
            ]);

            // Prepara el cuerpo de la solicitud para canjear el código por un token.
            const body = new URLSearchParams();
            body.append('grant_type', 'authorization_code');
            body.append('client_id', clientId);
            body.append('client_secret', clientSecret);
            body.append('code', code);
            body.append('redirect_uri', redirectUri);

            // Realiza la llamada a la API de Mercado Libre usando el fetch nativo.
            const response = await fetch('https://api.mercadolibre.com/oauth/token', {
                method: "POST",
                headers: {
                    "accept": "application/json",
                    "content-type": "application/x-www-form-urlencoded",
                },
                body: body.toString(),
            });

            // Maneja la respuesta de la API y guarda los datos en caso de éxito.
            if (!response.ok) {
                const errorData = await response.json();
                console.error("Error en la solicitud de token a Mercado Libre:", errorData);
                return res.status(500).send({ error: "Error al obtener el token de acceso", details: errorData });
            }

            const tokenData = await response.json();
            const dataToSave = buildDataObject(tokenData);
            await admin.firestore().collection('oAuthResponses').add(dataToSave);
            console.log("Documento de token creado exitosamente en Firestore.");

            return res.status(200).send({
                message: "¡Autorización completada! El token de acceso ha sido guardado.",
                token: tokenData,
            });

        } catch (error) {
            console.error("Error inesperado en el proceso de OAuth:", error.message);
            return res.status(500).send({ error: "Error inesperado al obtener el token de acceso", details: error.message });
        }
    } else {
        return res.status(405).send({ error: "Método no permitido" });
    }
});
