import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/orders.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Orders>?> getAllOrders() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Pedidos")
        .orderBy("dataDoChamado", descending: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<Orders> listOrders = [];
      for (var docSnapshot in querySnapshot.docs) {
        listOrders
            .add(Orders.fromFirestore(docSnapshot.data(), docSnapshot.id));
      }
      return listOrders;
    } else {
      return [];
    }
  }
}
