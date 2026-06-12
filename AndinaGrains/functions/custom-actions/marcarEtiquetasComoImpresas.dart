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

Future<bool> marcarEtiquetasComoImpresas(
    List<DocumentReference>? pedidosAActualizar) async {
  // --- FASE 1: VALIDACIÓN DE ENTRADA ---
  if (pedidosAActualizar == null || pedidosAActualizar.isEmpty) {
    print(
        'marcarEtiquetasComoImpresas INFO: La lista de pedidos a actualizar está vacía o es nula.');
    // No hay nada que actualizar, pero la operación no es un "fallo".
    // Devolvemos 'true' para no interrumpir el flujo del pipeline innecesariamente.
    return true;
  }

  print(
      'marcarEtiquetasComoImpresas INFO: Iniciando actualización de ${pedidosAActualizar.length} documentos.');

  // --- FASE 2: EJECUCIÓN Y PERSISTENCIA (ESCRITURA POR LOTES) ---
  final firestore = FirebaseFirestore.instance;
  WriteBatch batch = firestore.batch();
  int operationCount = 0;

  try {
    for (var docRef in pedidosAActualizar) {
      // Añadimos la operación de actualización al lote.
      batch.update(docRef, {'etiquetaImpresa': true});
      operationCount++;

      // Firestore tiene un límite de 500 operaciones por lote.
      // Si alcanzamos el límite, ejecutamos el lote actual y creamos uno nuevo.
      if (operationCount >= 500) {
        print(
            'marcarEtiquetasComoImpresas INFO: Límite de lote alcanzado. Ejecutando lote de 500 operaciones.');
        await batch.commit();
        batch = firestore.batch(); // Preparamos un nuevo lote.
        operationCount = 0;
      }
    }

    // Ejecutamos el último lote si tiene operaciones pendientes.
    if (operationCount > 0) {
      print(
          'marcarEtiquetasComoImpresas INFO: Ejecutando lote final con $operationCount operaciones.');
      await batch.commit();
    }

    print(
        'marcarEtiquetasComoImpresas INFO: Actualización completada exitosamente.');
    return true; // Éxito
  } catch (e) {
    print(
        'marcarEtiquetasComoImpresas ERROR: Ocurrió una excepción al ejecutar el lote. Error: $e');
    return false; // Fallo
  }
}
