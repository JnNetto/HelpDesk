import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/new_orders.dart';

class OrdersController {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addOrder(String titulo, String description, String autor,
      DateTime dataDoChamado, bool status) async {
    try {
      String formattedDate =
          '${dataDoChamado.day.toString().padLeft(2, '0')}/${dataDoChamado.month.toString().padLeft(2, '0')}/${dataDoChamado.year}';
      String formattedTime =
          '${dataDoChamado.hour.toString().padLeft(2, '0')}:${dataDoChamado.minute.toString().padLeft(2, '0')}';
      String data = '$formattedDate às $formattedTime';
      NewOrders order = NewOrders();
      order.titulo = titulo;
      order.descricao = description;
      order.autor = autor;
      order.dataDoChamado = data;
      order.status = status;

      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection('Pedidos').add({
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    // .catchError((erro) {
    //   print("Aconteceu o erro: " + erro.toString());
    // });
  }
}
