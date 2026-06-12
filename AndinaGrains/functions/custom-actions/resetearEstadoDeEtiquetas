// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future resetearEstadoDeEtiquetas(
  List<PedidosBSRecord> listadoPedidos,
  int? batchSize,
) async {
  // Add your function code here!
  // --- PASO 0: CONFIGURACIÓN INICIAL ---
  print(
      'PASO 0: Iniciando reseteo de etiquetas para ${listadoPedidos.length} pedidos.');

  final int effectiveBatchSize = batchSize ?? 500;

  // Si la lista de entrada está vacía, no hacemos nada.
  if (listadoPedidos.isEmpty) {
    print('La lista de pedidos a resetear está vacía. No se hace nada.');
    return;
  }

  try {
    // --- PASO 1: PREPARAR Y EJECUTAR LA ACTUALIZACIÓN EN LOTE ---
    List<Future<void>> commitPromises = [];
    WriteBatch currentBatch = FirebaseFirestore.instance.batch();
    int operationCount = 0;

    // Recorremos la lista de documentos que recibimos.
    for (var pedido in listadoPedidos) {
      // La única acción es establecer 'etiquetaImpresa' a false.
      currentBatch.update(pedido.reference, {'etiquetaImpresa': false});
      operationCount++;

      // Manejo de lotes para no superar el límite de Firestore.
      if (operationCount >= effectiveBatchSize) {
        print('Ejecutando lote de reseteo con $operationCount operaciones.');
        commitPromises.add(currentBatch.commit());
        currentBatch = FirebaseFirestore.instance.batch();
        operationCount = 0;
      }
    }

    // Ejecutamos el último lote si quedaron operaciones pendientes.
    if (operationCount > 0) {
      print(
          'Ejecutando último lote de reseteo con $operationCount operaciones.');
      commitPromises.add(currentBatch.commit());
    }

    // Esperamos a que todas las operaciones de escritura se completen.
    await Future.wait(commitPromises);

    print('--- Reseteo completado exitosamente para todos los pedidos ---');
  } catch (e) {
    print('Error crítico durante el reseteo de etiquetas: $e');
  }
}
