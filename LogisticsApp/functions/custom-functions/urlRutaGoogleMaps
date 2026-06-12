import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

String urlRutaGoogleMaps(
  DireccionDeServicioStruct origenServicio,
  List<DireccionDeServicioStruct> listadoParadas,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Verificación de nulos y de lista vacía.
  if (listadoParadas.isEmpty || origenServicio.latlong == null) {
    return '';
  }

  // 2. URL base para búsqueda y navegación.
  final baseUrl = 'https://www.google.com/maps/dir/?api=1';

  // 3. Parámetro de Origen (tomado del parámetro de entrada).
  final originParam =
      'origin=${origenServicio.latlong!.latitude},${origenServicio.latlong!.longitude}';

  // 4. Parámetro de Destino (es el último elemento de la lista).
  final destinationStruct = listadoParadas.last;
  if (destinationStruct.latlong == null) {
    return '';
  }
  final destinationParam =
      'destination=${destinationStruct.latlong!.latitude},${destinationStruct.latlong!.longitude}';

  // 5. Parámetro de Waypoints (son todos los elementos de la lista ANTES del último).
  String waypointsParam = '';
  if (listadoParadas.length > 1) {
    final waypoints = listadoParadas.sublist(0, listadoParadas.length - 1);
    List<String> waypointStrings = [];
    for (final parada in waypoints) {
      if (parada.latlong == null) {
        return '';
      }
      waypointStrings
          .add('${parada.latlong!.latitude},${parada.latlong!.longitude}');
    }
    waypointsParam = 'waypoints=${waypointStrings.join('%7C')}';
  }

  // 6. Ensamblar la URL final con todos los parámetros.
  String finalUrl = baseUrl;
  finalUrl += '&$originParam'; // Se añade el origen.
  finalUrl += '&$destinationParam';
  if (waypointsParam.isNotEmpty) {
    finalUrl += '&$waypointsParam';
  }

  return finalUrl;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
