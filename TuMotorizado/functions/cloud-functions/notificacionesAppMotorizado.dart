const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.notificacionesAppMotorizado = functions.https.onCall(async (data, context) => {
    // Validar que el usuario esté autenticado
    if (!context.auth) {
        throw new functions.https.HttpsError(
            'unauthenticated',
            'La función requiere que el usuario esté autenticado.'
        );
    }

    // Extraer los parámetros recibidos desde FlutterFlow
    const { userIdDestino, mensaje } = data;

    if (!userIdDestino) {
        throw new functions.https.HttpsError(
            'invalid-argument',
            'Falta el parámetro userIdDestino.'
        );
    }

    if (!mensaje) {
        throw new functions.https.HttpsError(
            'invalid-argument',
            'Falta el parámetro mensaje.'
        );
    }

    try {
        // URL de la Cloud Function webhook (que genera la notificación)
        const webhookUrl = 'https://us-central1-motorizados-3fd28.cloudfunctions.net/notificacionesClienteMotorizado';

        // Crear el payload (cuerpo de la solicitud POST)
        const payload = {
            userId: userIdDestino, // El destino de la notificación
            mensaje: mensaje,     // El mensaje de la notificación
        };

        // Configuración de la solicitud HTTP
        const fetch = require('node-fetch');
        const response = await fetch(webhookUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                //'Authorization': 'Bearer miTokenSeguro123', // Token para autenticar la solicitud
            },
            body: JSON.stringify(payload),
        });

        // Verificar si la solicitud fue exitosa
        if (!response.ok) {
            const errorText = await response.text();
            console.error('Error en el webhook:', errorText);
            throw new functions.https.HttpsError(
                'internal',
                'Error al enviar la notificación.',
                errorText
            );
        }

        // Respuesta exitosa
        return { success: true, message: 'Notificación enviada exitosamente.' };
    } catch (error) {
        console.error('Error al procesar la solicitud:', error);
        throw new functions.https.HttpsError(
            'internal',
            'Error al enviar la notificación.',
            error.message
        );
    }
});
