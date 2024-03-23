// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/exceptions/failure.dart';
import 'package:help_desk/widgets/detail_orders.dart';
import 'package:help_desk/widgets/detail_specific_orders.dart';

import '../model/new_orders.dart';
import '../model/orders.dart';
import '../model/users.dart';
import '../repository/orders_repository.dart';
import '../repository/users_repository.dart';
import '../util/AppCollors.dart';
import '../util/dados_gerais.dart';
import '../widgets/detail_historic_orders.dart';

class OrdersController extends ChangeNotifier {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) => _isLoading = value;

  void addOrder(String id, String titulo, String description, String autor,
      Timestamp dataDoChamado, bool status, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      NewOrders order = NewOrders();
      order.titulo = titulo;
      order.descricao = description;
      order.autor = autor;
      order.dataDoChamado = dataDoChamado;
      order.status = status;

      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentReference docRef = await db.collection('Pedidos').add({
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

      List<dynamic>? list = GeneralData.currentUser?.listOrders;
      String newId = docRef.id;

      await db.collection('Pedidos').doc(newId).set({
        'id': newId,
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

      list?.add({
        'id': newId,
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

      GeneralData.currentorders?.add(Orders(
          id: newId,
          titulo: order.titulo,
          descricao: order.descricao,
          autor: order.autor,
          dataDoChamado: order.dataDoChamado,
          status: order.status));

      await db.collection('Usuários').doc(id).update({
        'listaPedidos': list,
      });

      final OrdersRepository ordersRepository = OrdersRepository();
      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
      GeneralData.currentorders = listOrders;

      _isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      Failure.showErrorDialog(context, e);
    }

    // .catchError((erro) {
    //   print("Aconteceu o erro: " + erro.toString());
    // });
  }

  void deleteSpecificOrder(int index, BuildContext context) async {
    try {
      List<Orders>? list = GeneralData.currentorders;
      var item = list?[index];

      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('Pedidos').doc(item?.id).delete();

      GeneralData.currentorders?.removeAt(index);

      final OrdersRepository ordersRepository = OrdersRepository();
      ordersRepository.deleteAlredyDeletedOrders(item, context);

      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
      GeneralData.currentorders = listOrders;
    } on FirebaseException catch (e) {
      Failure.showErrorDialog(context, e);
    }
  }

  void acceptOrder(BuildContext context, int index) async {
    List<Orders>? listTemp = GeneralData.currentorders;
    Orders? item = listTemp?[index];

    if (item?.status == true) {
      Failure.showErrorDialog(context, 'Esse pedido já foi aceito');
    } else {
      try {
        isLoading = true;
        notifyListeners();

        List<dynamic>? acceptedOrders = GeneralData.currentUser?.ordersAccepted;
        acceptedOrders?.add({
          'id': item?.id,
          "titulo": item?.titulo,
          "descricao": item?.descricao,
          "autor": item?.autor,
          "dataDoChamado": item?.dataDoChamado,
          "status": true
        });

        List<dynamic>? listOrders = GeneralData.currentUser?.listOrders;
        listOrders?.add({
          'id': item?.id,
          "titulo": item?.titulo,
          "descricao": item?.descricao,
          "autor": item?.autor,
          "dataDoChamado": item?.dataDoChamado,
          "status": true
        });

        if (listTemp != null) {
          for (Orders itemTemp in listTemp) {
            if (itemTemp.id == item?.id) {
              item?.status = true;
            }
          }
        }
        String id = GeneralData.currentUser?.id ?? '';

        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('Pedidos').doc(item?.id).update({
          'status': true,
          'helperQueAceitou': GeneralData.currentUser?.name
        });
        await db.collection('Usuários').doc(id).update(
            {'listaPedidos': listOrders, 'pedidosAceitos': acceptedOrders});

        isLoading = false;
        notifyListeners();
      } on FirebaseException catch (e) {
        isLoading = false;
        notifyListeners();
        Failure.showErrorDialog(context, e);
      }
    }
  }

  void disacceptOrder(BuildContext context, int index) async {
    try {
      List<Orders>? listTemp = GeneralData.currentorders;
      Orders? item = listTemp?[index];

      List<dynamic>? acceptedOrders = GeneralData.currentUser?.ordersAccepted;
      if (acceptedOrders != null) {
        for (Map itemTemp in acceptedOrders) {
          if (itemTemp['id'] == item?.id) {
            acceptedOrders.remove(itemTemp);
            break;
          }
        }
      }

      GeneralData.currentUser?.ordersAccepted?.remove({
        'id': item?.id,
        "titulo": item?.titulo,
        "descricao": item?.descricao,
        "autor": item?.autor,
        'helperQueAceitou': item?.helperQueAceitou,
        "dataDoChamado": item?.dataDoChamado,
        "status": true
      });

      if (listTemp != null) {
        for (Orders itemTemp in listTemp) {
          if (itemTemp.id == item?.id) {
            itemTemp.helperQueAceitou = '';
            itemTemp.status = false;
            break;
          }
        }
      }

      String id = GeneralData.currentUser?.id ?? '';

      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection('Pedidos')
          .doc(item?.id)
          .update({'status': false, 'helperQueAceitou': ''});
      await db
          .collection('Usuários')
          .doc(id)
          .update({'pedidosAceitos': acceptedOrders});
    } on FirebaseException catch (e) {
      Failure.showErrorDialog(context, e);
    }
  }

  void updatePage(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final UsersRepository userRepository = UsersRepository();
      final OrdersRepository ordersRepository = OrdersRepository();
      Users? user = (await userRepository
          .getUserByEmail(GeneralData.currentUser?.email ?? ''));

      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
      GeneralData.currentUser = user;
      GeneralData.currentorders = listOrders;
      isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Failure.showErrorDialog(context, e);
    }
  }

  String dataFormatada(DateTime data) {
    DateTime dataDoChamado = data.toUtc().subtract(const Duration(hours: 3));
    String formattedDate =
        '${dataDoChamado.day.toString().padLeft(2, '0')}/${dataDoChamado.month.toString().padLeft(2, '0')}/${dataDoChamado.year}';
    String formattedTime =
        '${dataDoChamado.hour.toString().padLeft(2, '0')}:${dataDoChamado.minute.toString().padLeft(2, '0')}';
    return '$formattedDate às $formattedTime';
  }

  void exibirDetalhes(Orders obj, int index, BuildContext context,
      OrdersController controller, bool? specific) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (specific != null) {
          if (!specific) {
            return DetailOrders(obj: obj, index: index, controller: controller);
          } else {
            return DetailSpecificOrders(
              obj: obj,
              index: index,
              controller: controller,
              context: context,
            );
          }
        } else {
          return DetailHistoricOrders(
              obj: obj, index: index, controller: controller);
        }
      },
    );
  }

  Widget buildOrder(Orders obj, int index, BuildContext context,
      OrdersController controller, bool? specific) {
    return Container(
      width: 340,
      height: 100,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: const Color(0XFFF0F2F5),
          border: Border(
              left: BorderSide(
                  width: 4,
                  color: obj.status ?? false ? Colors.blue : Colors.red))),
      child: ListTile(
        onTap: () {
          updatePage(context);
          exibirDetalhes(obj, index, context, controller, specific);
        },
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          "${obj.titulo} - ${obj.autor}",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppCollors.textColorBlue)),
        ),
        subtitle: Text(
          dataFormatada(obj.dataDoChamado?.toDate() ?? DateTime.now()),
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppCollors.textDescriptionCard)),
        ),
      ),
    );
  }
}
