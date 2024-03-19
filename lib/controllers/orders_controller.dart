import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/exceptions/failure.dart';
import 'package:help_desk/util/detail_orders.dart';
import 'package:help_desk/util/detail_specific_orders.dart';

import '../model/new_orders.dart';
import '../model/orders.dart';
import '../repository/orders_repository.dart';
import '../util/AppCollors.dart';
import '../util/dados_gerais.dart';

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

      await db.collection('Usuários').doc(id).set({
        'email': GeneralData.currentUser?.email,
        'listaPedidos': list,
        'nome': GeneralData.currentUser?.name,
        'ocupacao': GeneralData.currentUser?.position,
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
      isLoading = true;
      notifyListeners();
      List<Orders>? list = GeneralData.currentorders;
      var item = list?[index];

      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('Pedidos').doc(item?.id).delete();

      GeneralData.currentorders?.removeAt(index);

      final OrdersRepository ordersRepository = OrdersRepository();
      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
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
    DateTime dataDoChamado = data.toUtc().subtract(Duration(hours: 3));
    String formattedDate =
        '${dataDoChamado.day.toString().padLeft(2, '0')}/${dataDoChamado.month.toString().padLeft(2, '0')}/${dataDoChamado.year}';
    String formattedTime =
        '${dataDoChamado.hour.toString().padLeft(2, '0')}:${dataDoChamado.minute.toString().padLeft(2, '0')}';
    return '$formattedDate às $formattedTime';
  }

  void exibirDetalhes(Orders obj, int index, BuildContext context,
      OrdersController controller, bool specific) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }

  Widget buildOrder(Orders obj, int index, BuildContext context,
      OrdersController controller, bool specific) {
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
