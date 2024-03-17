import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/orders_controller.dart';
import '../../model/orders.dart';
import '../../util/AppCollors.dart';
import '../../util/dados_gerais.dart';

class SpecificOrdersPage extends StatefulWidget {
  const SpecificOrdersPage({super.key});

  @override
  State<SpecificOrdersPage> createState() => _SpecificOrdersPageState();
}

class _SpecificOrdersPageState extends State<SpecificOrdersPage> {
  @override
  Widget build(BuildContext context) {
    String? nome = GeneralData.currentUser?.name;
    Orders order = Orders();
    print(GeneralData.currentUser?.listOrders.toString());
    List<Orders>? listOrders =
        order.mapToOrdersList(GeneralData.currentUser?.listOrders);

    return Consumer<OrdersController>(
        builder: (BuildContext context, OrdersController value, Widget? child) {
      OrdersController ordersController =
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
                          GeneralData.currentUser?.position == 'helper'
                              ? "Aqui estão os pedidos que você aceitou $nome!"
                              : "Aqui estão seus pedidos $nome",
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
                      margin: const EdgeInsets.only(right: 15, top: 15),
                      child: Container(
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
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: listOrders.length,
                    itemBuilder: (context, index) {
                      return ordersController.buildOrder(
                          listOrders[index], context);
                    }),
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
