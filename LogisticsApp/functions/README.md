# Aplicación de Transporte y Logística

Plataforma de gestión logística para pequeñas empresas, desarrollada en 
FlutterFlow y Firebase. Reemplaza la planificación manual de rutas con 
seguimiento en tiempo real, reportes automatizados y optimización de rutas.

## Cloud Functions
- **cargaMasivaExcel**: Función callable que procesa archivos Excel en formato 
  Base64, extrae sus filas y las persiste masivamente en Firestore usando 
  escritura por lotes (batch). Soporta colecciones configurables, validación 
  de encabezados y manejo de hasta 500 documentos por batch.
- **getPolylineFromAddresses**: Endpoint HTTP que recibe una lista de 
  coordenadas, consulta la API de Google Directions para calcular la ruta 
  óptima, decodifica la polilínea resultante y genera automáticamente una 
  imagen estática del mapa almacenada en Firebase Storage.
- **ocrFromImage**: Endpoint HTTP que recibe una imagen en formato Base64, 
  la procesa mediante Google Cloud Vision API y devuelve el texto extraído 
  completo. Incluye soporte CORS para solicitudes desde la app y manejo 
  de preflight OPTIONS.

## Custom Actions
- **atomizacionServicios**: Procesa una lista de viajes extrayendo direcciones 
  únicas de origen y destino, clasificándolas como pickup o dropoff para 
  construir rutas optimizadas sin duplicados.
- **excelToBase64**: Convierte archivos Excel a formato Base64 para su 
  procesamiento y transmisión dentro de la app.
- **generadorExcel**: Genera reportes en formato Excel a partir de datos 
  operativos del servicio.
- **getPolylineFromLatLngList**: Obtiene la polilínea de Google Maps a partir 
  de una lista de coordenadas para visualizar rutas en el mapa.
- **reOrdenar**: Permite reordenar manualmente las paradas de una ruta mediante 
  drag & drop, actualizando la lista de referencias en Firestore.
- **sendImageToOCR**: Envía imágenes en Base64 a la Cloud Function ocrFromImage 
  para extraer texto automáticamente de documentos físicos.

## Custom Functions
- **conteoDePasajerosEnServicio**: Calcula el número de pasajeros activos 
  en un servicio en curso.
- **reordenarDirecciones**: Reordena la lista de direcciones de una ruta 
  según criterios de optimización.
- **urlRutaGoogleMaps**: Construye una URL de Google Maps con origen, destino 
  y múltiples paradas intermedias para navegación directa desde la app.

## Custom Widgets
- **PrecomputedPolylineMap**: Widget interactivo de Google Maps que recibe una 
  polilínea precalculada y la anima progresivamente sobre el mapa durante 5 
  segundos. Interpola puntos intermedios para suavizar el trazado, ajusta 
  automáticamente la cámara para encuadrar la ruta completa, y coloca 
  marcadores diferenciados por color para origen (verde), destino (rojo) y 
  paradas intermedias (azul).
- **waypointsDirections**: Genera el string de waypoints requerido por la API 
  de Google Directions con soporte para optimización automática de ruta.
