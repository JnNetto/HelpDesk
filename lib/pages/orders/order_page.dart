import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders_controller.dart';
import '../../model/orders.dart';
import '../../util/AppCollors.dart';
import '../../util/dados_gerais.dart';

class OrderPage extends StatefulWidget {
  OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? nome = GeneralData.currentUser?.name;
  List<Orders>? listOrders = GeneralData.currentorders;

  void exibirModal(context, OrdersController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Novo chamado",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppCollors.textColorBlue)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: controller.tituloController,
                      decoration: InputDecoration(
                          hintText: "Título do chamado",
                          hintStyle: TextStyle(color: AppCollors.textColorBlue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      maxLines: 5,
                      controller: controller.descriptionController,
                      decoration: InputDecoration(
                          hintText: "Descrição",
                          hintStyle: TextStyle(color: AppCollors.textColorBlue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.addOrder(
                                controller.tituloController.text,
                                controller.descriptionController.text,
                                GeneralData.currentUser?.name ?? '',
                                DateTime.now()
                                    .toUtc()
                                    .subtract(const Duration(hours: 3)),
                                false,
                                context);
                          });
                          setState(() {});
                          Navigator.pop(context);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: AppCollors.primaryColor,
                        ),
                        child: const Text(
                          "Salvar Chamado",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersController>(
        builder: (BuildContext context, OrdersController value, Widget? child) {
      final OrdersController ordersController =
          Provider.of<OrdersController>(context);

      return Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(152),
              child: Row(
                children: [
                  Expanded(
                    flex: 17,
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: ListTile(
                        title: Text(
                          'HelpDesk',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 40,
                                  color: AppCollors.textColorBlue,
                                  fontWeight: FontWeight.w600)),
                        ),
                        subtitle: Text(
                          "Conta conosco, estamos aqui para lhe ajudar $nome!",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontSize: 15,
                            color: AppCollors.textColorBlue,
                          )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, top: 65),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppCollors.primaryColor,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.home,
                                  color: Colors.white,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppCollors.primaryColor,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  exibirModal(context, ordersController);
                                },
                                icon: const Icon(
                                  Icons.phone_callback_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      "Filtre pelo status do chamado",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppCollors.textColorBlue)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 124,
                            height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 2.2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppCollors.primaryColor),
                            child: const Text(
                              "Finalizados",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Container(
                            width: 124,
                            height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 2.2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppCollors.buttonRed),
                            child: const Text(
                              "Em aberto",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          itemCount: listOrders?.length,
                          itemBuilder: (context, index) {
                            return buildOrder(listOrders![index], context);
                          }),
                    )),
                  ],
                ),
              ),
            ),
          ),
          if (ordersController.isLoading)
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: AppCollors.primaryColor,
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
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
        obj.dataDoChamado.toString(),
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppCollors.textDescriptionCard)),
      ),
    ),
  );
}
