# TuMotorizado

Dos apps móviles interconectadas (cliente y conductor) para la gestión de 
entregas de paquetes, desarrolladas en FlutterFlow y Firebase.

## Cloud Functions
- **apiPruebaMotorizado**: Endpoint HTTP con autenticación por Bearer Token 
  que recibe datos externos vía webhook y los persiste en Firestore. 
  Implementa validación de método HTTP y manejo de errores.
- **notificacionesClienteMotorizado**: Envío de notificaciones push a usuarios 
  específicos mediante FCM. Gestiona múltiples tokens por usuario, limpieza 
  automática de tokens inválidos y soporte para Android e iOS.
- **notificacionesAppMotorizado**: Función callable desde FlutterFlow que 
  actúa como intermediario seguro para el envío de notificaciones, validando 
  autenticación del usuario antes de ejecutar el proceso.

## Custom Actions
- **direccionesGoogleMaps**: Integración con Google Maps API para obtener 
  direcciones y trazar rutas entre puntos de origen y destino.

## Custom Functions
- **decodeUrl**: Decodificación de URLs para el manejo de enlaces dinámicos.
- **generadorIdsPedidos**: Generación de IDs únicos para identificar pedidos.
- **mapaDeRuta**: Procesamiento de coordenadas para visualización de rutas.
- **separarLatitud**: Extracción de la latitud desde coordenadas compuestas.
- **separarLongitud**: Extracción de longitud desde coordenadas compuestas.
