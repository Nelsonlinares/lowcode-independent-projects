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

bool verificarProductoEnPedido(
  List<EstructuraPedidoStruct> listadoPedido,
  String skuProductoEscaneado,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  bool respuesta = false;

  // Buscar el SKU en la lista
  for (var elemento in listadoPedido) {
    print("SKU del producto en la lista: ${elemento.sKUproducto}");
    if (elemento.sKUproducto == skuProductoEscaneado) {
      // SKU encontrado y salir
      respuesta = true;
      break;
    }
  }

  return respuesta;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
