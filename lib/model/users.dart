import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? name;
  String? email;
  String? position;
  List? listOrders;

  Users({this.id, this.name, this.email, this.position, this.listOrders});

  factory Users.fromFirestore(DocumentSnapshot doc, var id) {
    Map data = doc.data() as Map;
    print(data.toString());
    return Users(
      id: id ?? '',
      name: data['nome'] ?? '',
      email: data['email'] ?? '',
      position: data['ocupacao'] ?? '',
      listOrders: data['listaPedidos'] ?? [],
    );
  }
}
