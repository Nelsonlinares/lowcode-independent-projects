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

List<EstructuraListadoSKUEscaneadoStruct> actualizarListado2(
  String nombreProducto,
  String sKUProducto,
  List<EstructuraListadoSKUEscaneadoStruct> listadoSKUEscaneado,
  String imagenProductoEscaneado,
  List<EstructuraPedidoStruct> listadoPedido,
  String descripcionProductoBS,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  String respuesta = "Black";
  int cantidad_pedido = 0;
  int cantidad_escaneada = 0;
//  Color valorColor = Colors.black;
  Color valorColor = Color(0xFF000000); //NEGRO
  bool elemento_en_pedido = false;
  bool elemento_en_listadoEscaneado = false;

  //1. VERIFICAR QUE EL PRODUCTO ESTA EN EL LISTADO DE PEDIDOS QUE HACE EL CLIENTE

  // Buscar el SKU en la lista del pedido que el cliente solicita
  for (var elemento in listadoPedido) {
    if (elemento.sKUproducto == sKUProducto) {
      // SKU encontrado, por lo tanto guardo cuanta cantidad necesito en el pedido
      cantidad_pedido = int.parse(elemento.cantidadProducto);
      elemento_en_pedido = true;
      break;
    }
  }

  //2. DETERMINAR SI EL PRODUCTO YA FUE ESCANEADO OTRAS VECES
  //   SI EL ELEMENTO EXISTE EN LA LISTA DE ESCANEADOS DEBO SUMARLE 1 A LA CANTIDAD

  for (var elemento in listadoSKUEscaneado) {
    if (elemento.sKUproducto == sKUProducto) {
      // SKU encontrado, por lo tanto guardo cuanta cantidad ha sido escaneada
      elemento.cantidadProducto += 1;
      cantidad_escaneada = elemento.cantidadProducto;
      elemento_en_listadoEscaneado = true;

      if (cantidad_escaneada < cantidad_pedido) {
        // Ya me pase de la cantidad necesaria, por lo tanto la respuesta será de tipo TRUE
        respuesta = "Black";
        valorColor = Color(0xFF000000); //NEGRO;
      }

      if (cantidad_escaneada == cantidad_pedido) {
        respuesta = "Green";
        valorColor = Color(0xFF88E817);
        ;
      }

      if (cantidad_escaneada > cantidad_pedido) {
        respuesta = "Red";
        valorColor = Color(0xFFFF0003);
      }

      elemento.verificacionDeCantidad = respuesta;
      elemento.colorTexto = valorColor;

      break;
    }
  }

  //3. REALIZAR LA ACCION DE AGREGAR EL ELEMENTO EN CASO DE QUE SEA UN PRODUCTO CORRECTO
  //   PERO NO SE ENCUENTRA ESCANEADO
  if (!elemento_en_listadoEscaneado && elemento_en_pedido) {
    cantidad_escaneada = 1;

    if (cantidad_escaneada < cantidad_pedido) {
      // Ya me pase de la cantidad necesaria, por lo tanto la respuesta será de tipo TRUE
      respuesta = "Black";
      valorColor = Color(0xFF000000);
    }

    if (cantidad_escaneada == cantidad_pedido) {
      respuesta = "Green";
      valorColor = Color(0xFF88E817);
      ;
    }

    if (cantidad_escaneada > cantidad_pedido) {
      respuesta = "Red";
      valorColor = Color(0xFFFF0003);
    }

    // Si el SKU no está en la lista, agregar un nuevo elemento
    EstructuraListadoSKUEscaneadoStruct nuevoElemento =
        EstructuraListadoSKUEscaneadoStruct(
      nombreProducto: nombreProducto,
      sKUproducto: sKUProducto,
      cantidadProducto: cantidad_escaneada,
      imagenProducto: imagenProductoEscaneado,
      verificacionDeCantidad: respuesta,
      colorTexto: valorColor,
      descripcionProducto: descripcionProductoBS,
    );
    listadoSKUEscaneado.add(nuevoElemento);
  }

  //4. REALIZAR LA ACCION DE AGREGAR EL ELEMENTO EN CASO DE QUE SEA UN PRODUCTO INCORRECTO
  //   PERO NO SE ENCUENTRA ESCANEADO
  if (!elemento_en_listadoEscaneado && !elemento_en_pedido) {
    // Si el SKU no está en la lista, agregar un nuevo elemento
    EstructuraListadoSKUEscaneadoStruct nuevoElemento =
        EstructuraListadoSKUEscaneadoStruct(
      nombreProducto: nombreProducto,
      sKUproducto: sKUProducto,
      cantidadProducto: 1,
      imagenProducto: imagenProductoEscaneado,
      verificacionDeCantidad: "Red",
      colorTexto: Color(0xFFFF0003),
      descripcionProducto: descripcionProductoBS,
    );
    listadoSKUEscaneado.add(nuevoElemento);
  }

  return listadoSKUEscaneado;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
