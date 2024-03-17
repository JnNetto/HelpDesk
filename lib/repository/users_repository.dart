import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/users.dart';

class UsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Users?> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Usuários')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Users.fromFirestore(
          querySnapshot.docs.first, querySnapshot.docs.first.id);
    } else {
      return null;
    }
  }
}
