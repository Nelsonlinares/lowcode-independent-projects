# Andina Grains (Colaboración)

App móvil de e-commerce con sincronización de productos y gestión de pedidos
en tiempo real, desarrollada en FlutterFlow y Firebase. Integra BSale y 
Mercado Libre como plataformas de ventas, y gestiona un sistema de escaneo 
de productos y impresión de etiquetas ZPL (en producción).

## Cloud Functions
- **oauthmercadolibre**: Maneja el flujo completo de OAuth2 con Mercado Libre. 
  Recibe el código de autorización, canjea las credenciales almacenadas en 
  Secret Manager por un token de acceso y lo persiste en Firestore.
- **verificacionPedidosPending**: Consulta todos los pedidos con estatus 
  "pending" en Firestore, los cruza contra la API de BSale con paginación 
  automática y actualiza su estado de pago. Gestiona credenciales mediante 
  Secret Manager y soporta modo producción y desarrollo configurable.
- **webhookReceiver**: Recibe notificaciones de BSale, responde inmediatamente 
  con 200 OK para evitar timeouts y procesa la lógica de negocio de forma 
  asíncrona. Implementa logging estructurado con ID de traza para trazabilidad 
  completa de cada solicitud.
- **webhookreceivermercadolibre**: Recibe y valida notificaciones de Mercado 
  Libre, responde de inmediato y persiste los eventos en Firestore usando el 
  ID del webhook como clave de documento, evitando duplicados en producción.

## Custom Actions
- **marcarEtiquetasComoImpresas**: Actualiza masivamente el campo 
  `etiquetaImpresa` a `true` en una lista de pedidos usando escritura por 
  lotes en Firestore, respetando el límite de 500 operaciones por batch.
- **procesarYMarcarEtiquetas**: Obtiene los códigos ZPL de una lista de 
  pedidos, filtra los válidos, los marca como impresos en Firestore de forma 
  atómica y devuelve el string ZPL concatenado listo para imprimir.
- **procesarYMarcarUnaEtiqueta**: Versión individual de la función anterior, 
  procesa y marca como impresa una sola etiqueta ZPL validando su formato 
  antes de actualizar Firestore.
- **resetearEstadoDeEtiquetas**: Restablece el campo `etiquetaImpresa` a 
  `false` en una lista de pedidos mediante escritura por lotes, útil para 
  reimpresión de etiquetas.

## Custom Functions
- **actualizarListado2**: Gestiona el listado de productos escaneados durante 
  el picking. Por cada escaneo verifica si el SKU pertenece al pedido, 
  actualiza la cantidad escaneada y asigna un color indicador: verde si 
  coincide con el pedido, negro si falta escanear más, y rojo si se excedió 
  la cantidad o el producto no pertenece al pedido.
- **creacionDeFechaParaConsultas**: Normaliza una fecha de entrada a medianoche 
  (00:00:00) para estandarizar las consultas por rango de fechas en Firestore.
- **eliminarElementoListadoEscaneado**: Elimina o reduce en uno la cantidad 
  de un producto en el listado de escaneo. Si la cantidad llega a cero el 
  elemento se elimina completamente, si no, actualiza el color indicador 
  según la cantidad restante versus la cantidad del pedido.
- **verificarCantidadProductosEscaneados**: Compara la cantidad escaneada de 
  un SKU contra la cantidad requerida en el pedido y devuelve un indicador 
  de color: negro si falta escanear, verde si coincide exactamente, y rojo 
  si se excedió la cantidad.
- **verificarFormatoDeEscaneo**: Valida y normaliza el string recibido del 
  escáner. Si el texto es un JSON con clave `id` extrae y devuelve ese valor, 
  si es texto plano lo devuelve tal cual, y si es nulo o vacío devuelve 
  `FORMATO_INVALIDO`.
- **verificarPedidoConEscaneo**: Compara el listado completo del pedido contra 
  el listado escaneado usando mapas de SKU y cantidades. Devuelve `true` solo 
  si todos los productos coinciden exactamente en SKU y cantidad, confirmando 
  que el picking está completo y correcto.
- **verificarProductoEnPedido**: Verifica si un SKU escaneado existe dentro 
  del listado del pedido activo. Devuelve `true` si el producto pertenece al 
  pedido y `false` si es un producto no solicitado.
