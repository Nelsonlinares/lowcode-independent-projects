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

List<EstructuraListadoSKUEscaneadoStruct>? eliminarElementoListadoEscaneado(
  List<EstructuraListadoSKUEscaneadoStruct> listaProductosEscaneados,
  String skuProductoEliminado,
  List<EstructuraPedidoStruct> listadoPedido,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  String respuesta = "Black";
  int cantidad_pedido = 0;
  int cantidad_escaneada = 0;
  int cantidad_escaneada_actualizada = 0;

  // Crear una nueva lista para almacenar los elementos que no se eliminarán
  List<EstructuraListadoSKUEscaneadoStruct> nuevaLista = [];

  // Recorrer la lista original y agregar los elementos que no se eliminarán a la nueva lista
  for (var elemento in listaProductosEscaneados) {
    if (elemento.sKUproducto != skuProductoEliminado) {
      nuevaLista.add(elemento);
    } else {
      // Procesar el elemento que se eliminará
      if (elemento.cantidadProducto > 1) {
        // Resto la cantidad
        elemento.cantidadProducto -= 1;
        cantidad_escaneada_actualizada = elemento.cantidadProducto;

        // Resto la cantidad del pedido
        for (var elemento2 in listadoPedido) {
          if (elemento2.sKUproducto == skuProductoEliminado) {
            cantidad_pedido = int.parse(elemento2.cantidadProducto);
            break;
          }
        }

        // Actualizo la respuesta y el color de texto
        if (cantidad_escaneada_actualizada < cantidad_pedido) {
          respuesta = "Black";
          elemento.colorTexto = Color(0xFF000000);
        }
        if (cantidad_escaneada_actualizada == cantidad_pedido) {
          respuesta = "Green";
          elemento.colorTexto = Color(0xFF88E817);
        }
        if (cantidad_escaneada_actualizada > cantidad_pedido) {
          respuesta = "Red";
          elemento.colorTexto = Color(0xFFFF0003);
        }

        elemento.verificacionDeCantidad = respuesta;
        nuevaLista.add(elemento);
      }
      // Si la cantidad es 1, se elimina completamente al no agregarlo a la nueva lista
    }
  }

  listaProductosEscaneados = nuevaLista;
  return listaProductosEscaneados;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
