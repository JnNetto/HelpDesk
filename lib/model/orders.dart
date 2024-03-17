import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? id;
  String? titulo;
  String? descricao;
  String? autor;
  Timestamp? dataDoChamado;
  bool? status;

  Orders(
      {this.id,
      this.titulo,
      this.descricao,
      this.autor,
      this.dataDoChamado,
      this.status});

  List<Orders> mapToOrdersList(List<dynamic>? mapList) {
    List<Orders> ordersList = [];
    for (var map in mapList!) {
      Orders order = Orders(
        id: map['id'],
        titulo: map['titulo'],
        descricao: map['descricao'],
        autor: map['autor'],
        dataDoChamado: map['dataDoChamado'],
        status: map['status'],
      );
      ordersList.add(order);
    }
    return ordersList;
  }

  factory Orders.fromFirestore(var data, var id) {
    return Orders(
      id: id ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      autor: data['autor'] ?? '',
      dataDoChamado: data['dataDoChamado'] ?? Timestamp.now(),
      status: data['status'] ?? false,
    );
  }
}
