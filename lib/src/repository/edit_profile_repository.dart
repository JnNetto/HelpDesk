import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/dados_gerais.dart';

class EditProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> editName(String newName) async {
    // Atualiza o nome do usuário no documento correspondente na coleção 'Usuários'
    await _firestore
        .collection("Usuários")
        .doc(GeneralData.currentUser?.id)
        .update({'nome': newName});

    if (GeneralData.currentUser?.position == 'helper') {
      // Se o usuário for um 'helper', atualiza o campo 'helperQueAceitou' nos documentos da coleção 'Pedidos'
      QuerySnapshot querySnapshot = await _firestore
          .collection("Pedidos")
          .where('helperQueAceitou', isEqualTo: GeneralData.currentUser?.name)
          .get();

      querySnapshot.docs.forEach((doc) {
        _firestore
            .collection("Pedidos")
            .doc(doc.id)
            .update({'helperQueAceitou': newName});
      });
    } else {
      // Se o usuário não for um 'helper', atualiza os campos 'autor' e 'pedidosAceitos' nos documentos da coleção 'Pedidos'
      QuerySnapshot querySnapshot =
          await _firestore.collection("Pedidos").get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Atualiza 'autor' no documento atual
        Map user = doc.data() as Map;
        print(user.toString());
        if (user['autor'] == GeneralData.currentUser?.name) {
          _firestore
              .collection("Pedidos")
              .doc(doc.id)
              .update({'autor': newName});
        }
      }

      QuerySnapshot querySnapshotPedidos =
          await _firestore.collection("Usuários").get();
      for (QueryDocumentSnapshot doc in querySnapshotPedidos.docs) {
        // Atualiza 'autor' no documento atual
        Map user = doc.data() as Map;
        if (user['autor'] == GeneralData.currentUser?.name) {
          _firestore
              .collection("Usuários")
              .doc(doc.id)
              .update({'nome': newName});
        }
        print(user.toString());
        // Verifica 'pedidosAceitos' no documento atual
        if (user.containsKey('pedidosAceitos')) {
          List<dynamic>? pedidosAceitos = user['pedidosAceitos'] as List;
          if (pedidosAceitos != null && pedidosAceitos != []) {
            // Se 'pedidosAceitos' existe e não for vazio, atualiza os 'autor' dentro da lista de pedidos aceitos
            for (var pedido in pedidosAceitos) {
              String name = pedido['autor'] as String;
              if (name == GeneralData.currentUser?.name) {
                pedido['autor'] = newName;
              }
            }
            // Atualiza 'pedidosAceitos' no documento atual
            _firestore
                .collection("Usuários")
                .doc(doc.id)
                .update({'pedidosAceitos': pedidosAceitos});
          }
        }
        if (user.containsKey('listaPedidos')) {
          List<dynamic>? listaPedidos = user['listaPedidos'] as List;
          if (listaPedidos != null && listaPedidos != []) {
            // Se 'pedidosAceitos' existe e não for vazio, atualiza os 'autor' dentro da lista de pedidos aceitos
            for (var pedido in listaPedidos) {
              String name = pedido['autor'] as String;
              if (name == GeneralData.currentUser?.name) {
                pedido['autor'] = newName;
              }
            }
            // Atualiza 'pedidosAceitos' no documento atual
            _firestore
                .collection("Usuários")
                .doc(doc.id)
                .update({'listaPedidos': listaPedidos});
          }
        }
      }
    }
  }
}
