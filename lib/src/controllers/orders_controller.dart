// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/src/exceptions/failure.dart';

import '../model/new_orders.dart';
import '../model/orders.dart';
import '../repository/orders_repository.dart';
import '../util/AppCollors.dart';
import '../util/dados_gerais.dart';
import '../widgets/detail_historic_orders.dart';
import '../widgets/detail_orders.dart';
import '../widgets/detail_specific_orders.dart';

class OrdersController extends ChangeNotifier {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) => _isLoading = value;

  StreamSubscription<List<Orders>>? _ordersSubscription;

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

      await db.collection('Usuários').doc(id).update({
        'listaPedidos': list,
      });

      final OrdersRepository ordersRepository = OrdersRepository();
      Stream<List<Orders>> listOrders = ordersRepository.getAllOrdersStream();

      _ordersSubscription?.cancel();
      _ordersSubscription = listOrders.listen((orders) {
        Stream<List<Orders>> ordersStream = Stream.value(orders);
        GeneralData.currentorders = ordersStream;
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      Failure.showErrorDialog(context, e);
    }
  }

  void deleteSpecificOrder(int index, BuildContext context) async {
    try {
      // Obtém os pedidos atuais do stream
      List<Orders>? list = await GeneralData.currentorders?.first;

      if (list != null && list.isNotEmpty && index < list.length) {
        var item = list[index];

        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('Pedidos').doc(item.id).delete();

        // Remove o pedido da lista local
        list.removeAt(index);

        // Atualiza o stream com a nova lista de pedidos
        GeneralData.currentorders = Stream.value(list);

        // Chama a função para deletar o pedido de documentos relacionados
        final OrdersRepository ordersRepository = OrdersRepository();
        await ordersRepository.deleteAlredyDeletedOrders(item, context);
      }
    } on FirebaseException catch (e) {
      Failure.showErrorDialog(context, e);
    }
  }

  void acceptOrder(BuildContext context, int index) async {
    try {
      // Obtém os pedidos atuais do stream
      List<Orders>? listTemp = await GeneralData.currentorders?.first;

      if (listTemp != null && index < listTemp.length) {
        Orders? item = listTemp[index];

        if (item.status == true) {
          Failure.showErrorDialog(context, 'Esse pedido já foi aceito');
        } else {
          isLoading = true;
          notifyListeners();

          List<dynamic>? acceptedOrders =
              GeneralData.currentUser?.ordersAccepted;
          acceptedOrders?.add({
            'id': item.id,
            "titulo": item.titulo,
            "descricao": item.descricao,
            "autor": item.autor,
            "dataDoChamado": item.dataDoChamado,
            "status": true
          });

          List<dynamic>? listOrders = GeneralData.currentUser?.listOrders;
          listOrders?.add({
            'id': item.id,
            "titulo": item.titulo,
            "descricao": item.descricao,
            "autor": item.autor,
            "dataDoChamado": item.dataDoChamado,
            "status": true
          });

          // Atualiza o status do pedido para true
          item.status = true;

          String id = GeneralData.currentUser?.id ?? '';

          FirebaseFirestore db = FirebaseFirestore.instance;
          await db.collection('Pedidos').doc(item.id).update({
            'status': true,
            'helperQueAceitou': GeneralData.currentUser?.name
          });
          await db.collection('Usuários').doc(id).update(
              {'listaPedidos': listOrders, 'pedidosAceitos': acceptedOrders});

          isLoading = false;
          notifyListeners();
        }
      } else {
        Failure.showErrorDialog(context, 'Erro ao aceitar o pedido');
      }
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Failure.showErrorDialog(context, e);
    }
  }

  void disacceptOrder(BuildContext context, int index) async {
    try {
      // Obtém os pedidos atuais do stream
      List<Orders>? listTemp = await GeneralData.currentorders?.first;

      if (listTemp != null && index < listTemp.length) {
        Orders? item = listTemp[index];

        List<dynamic>? acceptedOrders = GeneralData.currentUser?.ordersAccepted;
        if (acceptedOrders != null) {
          // Remove o pedido da lista de pedidos aceitos
          acceptedOrders.removeWhere((itemTemp) => itemTemp['id'] == item.id);
        }

        // Remove o pedido da lista de pedidos aceitos do usuário atual
        GeneralData.currentUser?.ordersAccepted
            ?.removeWhere((itemTemp) => itemTemp['id'] == item.id);

        // Atualiza o status do pedido para false
        item.helperQueAceitou = '';
        item.status = false;

        String id = GeneralData.currentUser?.id ?? '';

        FirebaseFirestore db = FirebaseFirestore.instance;
        await db
            .collection('Pedidos')
            .doc(item.id)
            .update({'status': false, 'helperQueAceitou': ''});
        await db
            .collection('Usuários')
            .doc(id)
            .update({'pedidosAceitos': acceptedOrders});
      } else {
        Failure.showErrorDialog(context, 'Erro ao recusar o pedido');
      }
    } on FirebaseException catch (e) {
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

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
