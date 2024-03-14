import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? name;
  String? email;
  String? position;

  Users({this.name, this.email, this.position});

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    print(data.toString());
    return Users(
      name: data['nome'] ?? '',
      email: data['email'] ?? '',
      position: data['ocupacao'] ?? '',
    );
  }
}
