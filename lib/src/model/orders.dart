import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? id;
  String? titulo;
  String? descricao;
  String? autor;
  String? helperQueAceitou;
  Timestamp? dataDoChamado;
  bool? status;

  Orders(
      {this.id,
      this.titulo,
      this.descricao,
      this.autor,
      this.helperQueAceitou,
      this.dataDoChamado,
      this.status});

  List<Orders> mapToOrdersList(List<dynamic>? mapList) {
    List<Orders> ordersList = [];
    if (mapList != null) {
      for (var item in mapList) {
        Orders order = Orders(
          id: item['id'],
          titulo: item['titulo'],
          descricao: item['descricao'],
          autor: item['autor'],
          helperQueAceitou: item['helperQueAceitou'] ?? '',
          dataDoChamado: item['dataDoChamado'],
          status: item['status'],
        );
        ordersList.add(order);
      }
      return ordersList;
    } else {
      return [];
    }
  }

  factory Orders.fromFirestore(var data) {
    return Orders(
      id: data['id'] ?? '',
      titulo: data['titulo'] ?? '',
      descricao: data['descricao'] ?? '',
      autor: data['autor'] ?? '',
      helperQueAceitou: data['helperQueAceitou'] ?? '',
      dataDoChamado: data['dataDoChamado'] ?? Timestamp.now(),
      status: data['status'] ?? false,
    );
  }
}
