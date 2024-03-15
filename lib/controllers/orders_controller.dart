import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void addOrder(String titulo, String description, String autor,
      DateTime dataDoChamado, bool status, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      String formattedDate =
          '${dataDoChamado.day.toString().padLeft(2, '0')}/${dataDoChamado.month.toString().padLeft(2, '0')}/${dataDoChamado.year}';
      String formattedTime =
          '${dataDoChamado.hour.toString().padLeft(2, '0')}:${dataDoChamado.minute.toString().padLeft(2, '0')}';
      String data = '$formattedDate às $formattedTime';
      NewOrders order = NewOrders();
      order.titulo = titulo;
      order.descricao = description;
      order.autor = autor;
      order.dataDoChamado = data;
      order.status = status;

      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection('Pedidos').add({
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

      final OrdersRepository ordersRepository = OrdersRepository();
      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
      GeneralData.currentorders = listOrders;

      _isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }

    // .catchError((erro) {
    //   print("Aconteceu o erro: " + erro.toString());
    // });
  }
}

void exibirDetalhes(Orders obj, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
            child: Text(
          obj.titulo ?? '',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppCollors.textColorBlue)),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Nome: ${obj.autor}",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppCollors.textColorBlue)),
            ),
            Text(
              "Data: ${obj.dataDoChamado}",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppCollors.textColorBlue)),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              obj.descricao ?? '',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 12, color: AppCollors.textColorBlue)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Voltar'),
          ),
        ],
      );
    },
  );
}
