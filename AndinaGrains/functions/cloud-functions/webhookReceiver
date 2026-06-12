const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Inicializa Firestore
const db = admin.firestore();

// ============================================================================
// CONFIGURACIÓN PARA LOGGING ESTRUCTURADO
// ============================================================================
const LOGGER_CONFIG = {
    /**
     * Registra un mensaje informativo.
     * @param {string} traceId - El ID para agrupar los logs de una solicitud.
     * @param {string} step - El paso del proceso donde ocurre el log.
     * @param {string} message - El mensaje a registrar.
     * @param {object} [details={}] - Datos adicionales para dar contexto.
     */
    info: (traceId, step, message, details = {}) => {
        console.log(JSON.stringify({
            severity: 'INFO',
            traceId,
            step,
            message,
            details,
        }));
    },

    /**
     * Registra una advertencia.
     * @param {string} traceId - El ID para agrupar los logs de una solicitud.
     * @param {string} step - El paso del proceso.
     * @param {string} message - El mensaje de advertencia.
     * @param {object} [details={}] - Datos adicionales.
     */
    warn: (traceId, step, message, details = {}) => {
        console.warn(JSON.stringify({
            severity: 'WARNING',
            traceId,
            step,
            message,
            details,
        }));
    },

    /**
     * Registra un error.
     * @param {string} traceId - El ID para agrupar los logs de una solicitud.
     * @param {string} step - El paso del proceso donde ocurrió el error.
     * @param {string} message - El mensaje de error.
     * @param {Error|object} error - El objeto de error o detalles adicionales.
     */
    error: (traceId, step, message, error = {}) => {
        console.error(JSON.stringify({
            severity: 'ERROR',
            traceId,
            step,
            message,
            error: {
                message: error.message,
                stack: error.stack,
                details: error,
            },
        }));
    },
};

// ============================================================================
// CONFIGURACIÓN DE RESPUESTAS
// ============================================================================
const SUCCESS_MESSAGE = { message: "Solicitud recibida y en proceso" };
const INVALID_REQUEST_MESSAGE = { error: "Cuerpo de la solicitud no válido" };
const METHOD_NOT_ALLOWED_MESSAGE = { error: "Método no permitido" };


exports.webhookReceiver = functions
    .region('us-central1')
    .runWith({ memory: '128MB' })
    .https.onRequest(async (req, res) => {
        
        // ** PASO 1: OBTENER ID DE TRAZA **
        // Usamos 'resourceId' como ID de traza. Si no viene, se usa un valor por defecto.
        const traceId = req.body?.resourceId || 'endpointID-no-proporcionado';

        LOGGER_CONFIG.info(traceId, 'START', 'Función webhookReceiver iniciada.');

        try {
            // ** PASO 2: VALIDAR MÉTODO Y CUERPO DE LA SOLICITUD **
            if (req.method !== 'POST') {
                LOGGER_CONFIG.warn(traceId, 'VALIDATION', `Método no permitido: ${req.method}`);
                return res.status(405).send(METHOD_NOT_ALLOWED_MESSAGE);
            }

            if (!req.body || !req.body.action) {
                LOGGER_CONFIG.warn(traceId, 'VALIDATION', 'El cuerpo de la solicitud es inválido o la acción no está presente.', { body: req.body });
                return res.status(400).send(INVALID_REQUEST_MESSAGE);
            }
            LOGGER_CONFIG.info(traceId, 'VALIDATION', 'La solicitud ha superado las validaciones iniciales.');

            // ** PASO 3: RESPONDER INMEDIATAMENTE **
            LOGGER_CONFIG.info(traceId, 'RESPONSE', 'Enviando respuesta 200 OK para confirmar recepción.');
            res.status(200).send(SUCCESS_MESSAGE);

            // ** PASO 4: PROCESAR LA LÓGICA DE NEGOCIO ASÍNCRONAMENTE **
            const action = req.body.action.toUpperCase();
            LOGGER_CONFIG.info(traceId, 'PROCESS_ACTION', `Procesando acción: ${action}`);

            if (action === "POST") {
                const webhookData = {
                    cpnID: req.body.cpnId || 10,
                    endpoint: req.body.resource || "1",
                    endpointID: req.body.resourceId || 1, // Mapeo a endpointID
                    topico: req.body.topic || "1",
                    tipoRequest: action,
                    accionSend: req.body.send || 1,
                    oficinaID: req.body.officeId || 1,
                    listaPreciosID: req.body.priceListId || "1",
                    fechaHoraRecepcion: admin.firestore.FieldValue.serverTimestamp(),
                };
                LOGGER_CONFIG.info(traceId, 'FIRESTORE_WRITE', 'Intentando guardar datos en Firestore.', { data: webhookData });               
                await db.collection("webhooksRecibidos").add(webhookData);
                LOGGER_CONFIG.info(traceId, 'FIRESTORE_WRITE', 'Webhook almacenado exitosamente en Firestore.');
            } else {
                LOGGER_CONFIG.warn(traceId, 'PROCESS_ACTION', `La acción '${action}' no es 'POST' y no se procesará.`, { action });
            }

        } catch (error) {
            // ** PASO 5: MANEJO CENTRALIZADO DE ERRORES **
            LOGGER_CONFIG.error(traceId, 'UNHANDLED_ERROR', 'Ha ocurrido un error inesperado en la ejecución.', error);
            if (!res.headersSent) {
                res.status(500).send({ error: 'Error interno del servidor.', traceId });
            }
        }
    });
