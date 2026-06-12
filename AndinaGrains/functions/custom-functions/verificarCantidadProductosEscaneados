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

String verificarCantidadProductosEscaneados(
  List<EstructuraPedidoStruct> listaPedido,
  List<EstructuraListadoSKUEscaneadoStruct> listaEscaneada,
  String skuEscaneado,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  String respuesta = "Black";
  int cantidad_pedido = 0;
  int cantidad_escaneada = 0;

  // Buscar el SKU en la lista del pedido

  for (var elemento in listaPedido) {
    if (elemento.sKUproducto == skuEscaneado) {
      // SKU encontrado, por lo tanto guardo cuanta cantidad necesito en el pedido
      cantidad_pedido = int.parse(elemento.cantidadProducto);
      break;
    }
  }

  // Buscar el SKU en la lista Escaneada

  for (var elemento in listaEscaneada) {
    if (elemento.sKUproducto == skuEscaneado) {
      // SKU encontrado, por lo tanto guardo cuanta cantidad que tengo escaneada
      cantidad_escaneada = elemento.cantidadProducto;
      break;
    }
  }

  if (cantidad_escaneada < cantidad_pedido) {
    // Ya me pase de la cantidad necesaria, por lo tanto la respuesta será de tipo TRUE
    respuesta = "Black";
  }

  if (cantidad_escaneada == cantidad_pedido) {
    respuesta = "Green";
  }

  if (cantidad_escaneada > cantidad_pedido) {
    respuesta = "Red";
  }

  return respuesta;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
