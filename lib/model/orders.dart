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
