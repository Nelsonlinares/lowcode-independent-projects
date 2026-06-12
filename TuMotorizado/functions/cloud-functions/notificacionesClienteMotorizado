const functions = require('firebase-functions');
const admin = require('firebase-admin');
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.notificacionesClienteMotorizado = functions.https.onRequest(async (req, res) => {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Método no permitido. Solo se permite POST.' });
    }

    const { mensaje, userId } = req.body;
    console.log('Datos recibidos:', { mensaje, userId });

    try {
        const userDoc = await admin.firestore().collection('Usuarios').doc(userId).get();

        if (!userDoc.exists) {
            return res.status(404).json({ error: 'Usuario no encontrado.' });
        }

        const tokensSnapshot = await userDoc.ref.collection('fcm_tokens').get();
        console.log('Subcolección fcm_tokens encontrada:', !tokensSnapshot.empty);

        if (tokensSnapshot.empty) {
            return res.status(400).json({ 
                error: 'No se encontraron tokens en la subcolección',
                userId: userId
            });
        }

        const tokens = tokensSnapshot.docs
            .map(doc => ({ id: doc.id, token: doc.data().fcm_token }))
            .filter(item => item.token);

        if (tokens.length === 0) {
            return res.status(400).json({ 
                error: 'No se encontraron tokens válidos en los documentos',
                userId: userId
            });
        }

        const resultados = {
            exitosos: [],
            fallidos: [],
            tokensEliminados: []
        };

        // Intentar enviar a todos los tokens
        for (const { id, token } of tokens) {
            try {
                const notification = {
                    notification: {
                        title: 'Notificación',
                        body: mensaje
                    },
                    data: {
                        // Campos específicos para FlutterFlow
                        pageParameter: 'HomePage', // Este es el nombre exacto de tu página en FlutterFlow
                        notificationType: 'navigation',
                        navigationPath: 'tumotorizadoclapp/HomePage', // La ruta exacta de navegación
                        userId: userId,
                        timestamp: Date.now().toString()
                    },
                    android: {
                        priority: 'high',
                        notification: {
                            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                            priority: 'max'
                        }
                    },
                    apns: {
                        headers: {
                            'apns-priority': '10'
                        },
                        payload: {
                            aps: {
                                sound: 'default',
                                category: 'NAVIGATION'
                            }
                        }
                    },
                    token: token
                };

                const response = await admin.messaging().send(notification);
                resultados.exitosos.push({
                    token: token.substring(0, 10) + '...',
                    messageId: response
                });

            } catch (error) {
                if (error.code === 'messaging/registration-token-not-registered') {
                    await userDoc.ref.collection('fcm_tokens').doc(id).delete();
                    resultados.tokensEliminados.push(id);
                } else {
                    resultados.fallidos.push({
                        token: token.substring(0, 10) + '...',
                        error: error.message
                    });
                }
            }
        }

        // Evaluar resultados
        const exito = resultados.exitosos.length > 0;
        const resumen = {
            totalTokens: tokens.length,
            notificacionesExitosas: resultados.exitosos.length,
            notificacionesFallidas: resultados.fallidos.length,
            tokensEliminados: resultados.tokensEliminados.length
        };

        if (!exito) {
            return res.status(400).json({
                error: 'No se pudo enviar ninguna notificación',
                resumen: resumen,
                detalles: resultados
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Proceso completado',
            resumen: resumen,
            detalles: resultados
        });

    } catch (error) {
        console.error('Error en la función:', error);
        return res.status(500).json({
            error: 'Error interno del servidor',
            detalles: error.message,
            tipo: error.constructor.name
        });
    }
});
