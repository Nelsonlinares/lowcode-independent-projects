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

import 'package:google_directions_api/google_directions_api.dart';

Future<void> direccionesGoogleMaps(
  String origen,
  String destino,
) async {
  try {
    // ANDROID
    //DirectionsService.init('API_KEY');

    // WEB
    DirectionsService.init('API_KEY');

    final directionsService = DirectionsService();

    final request = DirectionsRequest(
      origin: 'Freire 1627, Concepción',
      destination: 'Av Campos Deportivos 340, Concepción',
      travelMode: TravelMode.driving,
    );

    directionsService.route(request, (response, status) {
      if (status == DirectionsStatus.ok) {
        // Haz algo con la respuesta exitosa
        print('Ruta exitosa: ${response.routes}');
        // Realiza acciones adicionales si es necesario
      } else {
        // Haz algo con la respuesta de error
        print('Error en la solicitud de rutas: $status');
        // Realiza acciones adicionales para manejar el error
      }
    });
  } catch (error) {
    // Maneja cualquier error que pueda ocurrir durante la solicitud de rutas
    print('Error general: $error');
    // Realiza acciones adicionales para manejar el error
  }
}
