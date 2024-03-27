import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrders {
  String? _id;
  String? _titulo;
  String? _descricao;
  String? _autor;
  Timestamp? _dataDoChamado;
  bool? _status;

  get id => _id;

  set id(value) => _id = value;

  get titulo => _titulo;

  set titulo(value) => _titulo = value;

  get descricao => _descricao;

  set descricao(value) => _descricao = value;

  get autor => _autor;

  set autor(value) => _autor = value;

  get dataDoChamado => _dataDoChamado;

  set dataDoChamado(value) => _dataDoChamado = value;

  get status => _status;

  set status(value) => _status = value;

  NewOrders();
}
