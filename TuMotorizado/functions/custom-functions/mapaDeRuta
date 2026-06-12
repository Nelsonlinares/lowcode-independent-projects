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

String mapaDeRuta(
  LatLng latlongorigen,
  LatLng latlongdestino,
  String geometria,
  double ancho,
  double alto,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  String accessToken =
      'TOKEN_MAPBOX'; 

  String origen = '${latlongorigen.longitude},${latlongorigen.latitude}';
  String destino = '${latlongdestino.longitude},${latlongdestino.latitude}';
  String encodedGeometria = Uri.encodeComponent(geometria);

  //String url = 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s-a+000($origen),pin-s-b+000($destino),path-3+e41111-1($encodedGeometria)/auto/500x500@2x?padding=120%2C120%2C120%2C120&access_token=$accessToken';

  //String dimension = ancho.toString() + 'x' + alto.toString
  String dimension = '1080' + 'x' + '1080';
  String url =
      'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/pin-s-a+000($origen),pin-s-b+000($destino),path-3+e41111-1($encodedGeometria)/auto/$dimension@2x?padding=120%2C120%2C120%2C120&access_token=$accessToken';

  return url;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
