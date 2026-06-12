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

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '/flutter_flow/lat_lng.dart';

Future<List<LatLng>> getPolylineFromLatLngList(
  List<LatLng> points,
  DocumentReference docRef,
) async {
  final url = Uri.parse(
    'https://us-central1-transmol-produccion.cloudfunctions.net/getPolylineFromAddresses',
  );

  if (points.length < 2) {
    throw Exception('Se requieren al menos 2 puntos para calcular la ruta.');
  }

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'locations':
          points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
      'docPath': docRef.path,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al obtener la polilínea: ${response.body}');
  }

  final decoded = json.decode(response.body);

  if (!decoded.containsKey('points')) {
    throw Exception(
        'La respuesta de la Cloud Function no contiene puntos válidos.');
  }

  //Escritura de imagen en la colección
  final imageUrl = decoded['imageUrl'];
  if (imageUrl != null && imageUrl is String && imageUrl.startsWith('http')) {
    await docRef.update({'staticMapUrl': imageUrl});
  }

  final pointsJson = decoded['points'] as List<dynamic>;
  return pointsJson
      .map((coord) => LatLng(
            coord['lat'] as double,
            coord['lng'] as double,
          ))
      .toList();
}
