// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/exceptions/failure.dart';
import '../model/orders.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Orders>?> getAllOrders() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Pedidos")
        .orderBy("dataDoChamado", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<Orders> listOrders = [];
      for (var docSnapshot in querySnapshot.docs) {
        listOrders.add(Orders.fromFirestore(docSnapshot.data()));
      }
      return listOrders;
    } else {
      return [];
    }
  }

  Future<void> deleteAlredyDeletedOrders(
      Orders? order, BuildContext context) async {
    try {
      // Encontrar o documento do usuário que contém a lista de pedidos aceitos
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Usuários')
          .where('pedidosAceitos', arrayContains: {
        'id': order?.id,
        "titulo": order?.titulo,
        "descricao": order?.descricao,
        "autor": order?.autor,
        "dataDoChamado": order?.dataDoChamado,
        "status": true
      }).get();

      // Se encontrarmos um documento
      if (querySnapshot.docs.isNotEmpty) {
        // Iterar sobre os documentos encontrados
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) async {
          // Obter a lista de pedidos aceitos
          List<dynamic> pedidosAceitos = doc['pedidosAceitos'];

          // Remover o pedido com o ID fornecido da lista
          pedidosAceitos.removeWhere((pedido) => pedido['id'] == order?.id);

          // Atualizar o documento no Firestore com a lista modificada
          await FirebaseFirestore.instance
              .collection('Usuários')
              .doc(doc.id)
              .update({'pedidosAceitos': pedidosAceitos});
        });
      } else {}
    } catch (e) {
      Failure.showErrorDialog(context, e);
    }
  }
}
