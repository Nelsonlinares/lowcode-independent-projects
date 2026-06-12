// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<DireccionAtomizadaStruct>> atomizacionServiciosCopy(
    List<DocumentReference> viajesDesglosados,
    DocumentReference conductorRef) async {
  final Map<String, DireccionAtomizadaStruct> direccionesUnicas = {};

  for (final viajeRef in viajesDesglosados) {
    final viajeSnap = await viajeRef.get();
    if (!viajeSnap.exists) continue;

    final viaje = viajeSnap.data() as Map<String, dynamic>;

    final origen = viaje['direccionOrigenNueva'] as Map<String, dynamic>?;
    final destino = viaje['direccionDestinoNueva'] as Map<String, dynamic>?;

    final origenDireccion = origen?['direccionCompleta']?.toString();
    final destinoDireccion = destino?['direccionCompleta']?.toString();

    // Procesar ORIGEN
    if (origenDireccion != null && origenDireccion.isNotEmpty) {
      if (!direccionesUnicas.containsKey(origenDireccion)) {
        direccionesUnicas[origenDireccion] = DireccionAtomizadaStruct(
          direccion: origenDireccion,
          pickup: viajeRef,
          dropoff: null,
          completado: false,
          etiqueta: 'pickup',
        );
      } else {
        final existente = direccionesUnicas[origenDireccion]!;
        direccionesUnicas[origenDireccion] = DireccionAtomizadaStruct(
          direccion: existente.direccion,
          pickup: existente.pickup ?? viajeRef,
          dropoff: existente.dropoff,
          completado: existente.completado,
          etiqueta: existente.etiqueta,
        );
      }
    }

    // Procesar DESTINO
    if (destinoDireccion != null && destinoDireccion.isNotEmpty) {
      if (!direccionesUnicas.containsKey(destinoDireccion)) {
        direccionesUnicas[destinoDireccion] = DireccionAtomizadaStruct(
          direccion: destinoDireccion,
          pickup: null,
          dropoff: viajeRef,
          completado: false,
          etiqueta: 'dropoff',
        );
      } else {
        final existente = direccionesUnicas[destinoDireccion]!;
        direccionesUnicas[destinoDireccion] = DireccionAtomizadaStruct(
          direccion: existente.direccion,
          pickup: existente.pickup,
          dropoff: existente.dropoff ?? viajeRef,
          completado: existente.completado,
          etiqueta: existente.etiqueta,
        );
      }
    }
  }

  return direccionesUnicas.values.toList();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
