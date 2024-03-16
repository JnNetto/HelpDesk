import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrders {
  String? _id;
  String? _titulo;
  String? _descricao;
  String? _autor;
  Timestamp? _dataDoChamado;
  bool? _status;
  String? get id => this._id;

  set id(String? value) => this._id = value;

  get titulo => this._titulo;

  set titulo(value) => this._titulo = value;

  get descricao => this._descricao;

  set descricao(value) => this._descricao = value;

  get autor => this._autor;

  set autor(value) => this._autor = value;

  get dataDoChamado => this._dataDoChamado;

  set dataDoChamado(value) => this._dataDoChamado = value;

  get status => this._status;

  set status(value) => this._status = value;

  NewOrders();
}
