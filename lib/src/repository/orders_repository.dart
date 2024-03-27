// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:help_desk/src/exceptions/failure.dart';
import 'package:help_desk/src/util/dados_gerais.dart';
import '../model/orders.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Orders>> getAllOrdersStream() {
    return _firestore
        .collection("Pedidos")
        .orderBy("dataDoChamado", descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Orders.fromFirestore(doc.data()))
            .toList());
  }

  Stream<List<Orders>> getSpecificOrdersStream() {
    if (GeneralData.currentUser?.position == 'helper') {
      return _firestore
          .collection("Usuários")
          .where("nome", isEqualTo: GeneralData.currentUser?.name)
          .snapshots()
          .map((querySnapshot) {
        // Verificar se há algum documento retornado pela consulta
        if (querySnapshot.docs.isNotEmpty) {
          // Acessar o primeiro documento retornado (deve haver apenas um, já que estamos filtrando pelo ID do usuário)
          var userData = querySnapshot.docs.first.data();

          // Verificar se o campo 'pedidosAceitos' existe e é uma lista
          if (userData.containsKey('pedidosAceitos')) {
            List pedidosAceitos = userData['pedidosAceitos'];

            // Mapear a lista de pedidos aceitos para o tipo Orders
            return (pedidosAceitos)
                .map((orderData) => Orders.fromFirestore(orderData))
                .toList();
          }
        }
        // Caso não haja pedidos aceitos ou se o documento do usuário não existir, retornar uma lista vazia
        return [];
      });
    } else {
      return _firestore
          .collection("Pedidos")
          .where("autor", isEqualTo: GeneralData.currentUser?.name)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => Orders.fromFirestore(doc.data()))
              .toList());
    }
  }

  Stream<List<Orders>> getHistoricOrdersStream() {
    if (GeneralData.currentUser?.position == 'helper') {
      return _firestore
          .collection("Usuários")
          .where("nome", isEqualTo: GeneralData.currentUser?.name)
          .snapshots()
          .map((querySnapshot) {
        // Verificar se há algum documento retornado pela consulta
        if (querySnapshot.docs.isNotEmpty) {
          // Acessar o primeiro documento retornado (deve haver apenas um, já que estamos filtrando pelo ID do usuário)
          var userData = querySnapshot.docs.first.data();

          // Verificar se o campo 'listaPedidos' existe e é uma lista
          if (userData.containsKey('listaPedidos')) {
            List listaPedidos = userData['listaPedidos'];

            // Mapear a lista de pedidos para o tipo Orders
            return (listaPedidos)
                .map((orderData) => Orders.fromFirestore(orderData))
                .toList();
          }
        }
        // Caso não haja pedidos aceitos ou se o documento do usuário não existir, retornar uma lista vazia
        return [];
      });
    } else {
      return _firestore
          .collection("Pedidos")
          .where("autor", isEqualTo: GeneralData.currentUser?.name)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => Orders.fromFirestore(doc.data()))
              .toList());
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
    } on FirebaseException catch (e) {
      Failure.showErrorDialog(context, e);
    }
  }
}
