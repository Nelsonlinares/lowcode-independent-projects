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

bool verificarPedidoConEscaneo(
  List<EstructuraPedidoStruct> listadoPedido,
  List<EstructuraListadoSKUEscaneadoStruct> listadoSKUEscaneado,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  Map<String, int> mapaPedido = {};
  Map<String, int> mapaEscaneado = {};

  // Llenar los mapas con los elementos de las listas
  for (EstructuraPedidoStruct elemento in listadoPedido) {
    String nombreProducto = elemento.sKUproducto!;
    int cantidadProducto = int.parse(elemento.cantidadProducto!);
    mapaPedido[nombreProducto] = cantidadProducto;
  }

  for (EstructuraListadoSKUEscaneadoStruct elemento in listadoSKUEscaneado) {
    String nombreProducto = elemento.sKUproducto!;
    int cantidadProducto = elemento.cantidadProducto!;
    mapaEscaneado[nombreProducto] = cantidadProducto;
  }

  // Comparar los mapas
  if (mapaPedido.length != mapaEscaneado.length) {
    return false; // Si los mapas tienen diferente longitud, las listas no son iguales
  }

  for (String nombreProducto in mapaPedido.keys) {
    if (!mapaEscaneado.containsKey(nombreProducto) ||
        mapaPedido[nombreProducto] != mapaEscaneado[nombreProducto]) {
      return false; // Si hay alguna diferencia en los nombres o cantidades, las listas no son iguales
    }
  }

  return true; // Si se llega a este punto, las listas son iguales
  /// MODIFY CODE ONLY ABOVE THIS LINE
}
