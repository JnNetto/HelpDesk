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

      await db.collection('Pedidos').add({
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

      List<dynamic>? list = GeneralData.currentUser?.listOrders;

      list?.add({
        "id": id,
        "titulo": order.titulo,
        "descricao": order.descricao,
        "autor": order.autor,
        "dataDoChamado": order.dataDoChamado,
        "status": order.status
      });

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
      print(e.toString());
    }

    // .catchError((erro) {
    //   print("Aconteceu o erro: " + erro.toString());
    // });
  }

  String dataFormatada(DateTime data) {
    DateTime dataDoChamado = data.toUtc().subtract(Duration(hours: 3));
    String formattedDate =
        '${dataDoChamado.day.toString().padLeft(2, '0')}/${dataDoChamado.month.toString().padLeft(2, '0')}/${dataDoChamado.year}';
    String formattedTime =
        '${dataDoChamado.hour.toString().padLeft(2, '0')}:${dataDoChamado.minute.toString().padLeft(2, '0')}';
    return '$formattedDate às $formattedTime';
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
                "Data: ${dataFormatada(obj.dataDoChamado?.toDate() ?? DateTime.now())}",
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
                obj.id ?? '',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 12, color: AppCollors.textColorBlue)),
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

  Widget buildOrder(Orders obj, BuildContext context) {
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
          exibirDetalhes(obj, context);
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
