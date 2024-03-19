import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/controllers/orders_controller.dart';
import 'package:help_desk/util/AppCollors.dart';
import 'package:help_desk/util/dados_gerais.dart';

import '../model/orders.dart';

class DetailOrders extends ChangeNotifier {
  static Widget alertDialogOrders(Orders obj, int index, BuildContext context,
      OrdersController controller) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
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
                "Data: ${controller.dataFormatada(obj.dataDoChamado?.toDate() ?? DateTime.now())}",
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
                    textStyle: TextStyle(
                        fontSize: 12, color: AppCollors.textColorBlue)),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: GeneralData.currentUser?.position == 'helper',
              child: TextButton(
                onPressed: () {},
                child: const Text('Aceitar pedido'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget alertDialogSpecificOrders(Orders obj, int index,
      BuildContext context, OrdersController controller) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
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
                "Data: ${controller.dataFormatada(obj.dataDoChamado?.toDate() ?? DateTime.now())}",
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
                    textStyle: TextStyle(
                        fontSize: 12, color: AppCollors.textColorBlue)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.deleteSpecificOrder(index, controller, context);
                // Navigator.pushNamed(context, '/home');
                Navigator.of(context).pop();
              },
              child: Text(GeneralData.currentUser?.position == 'helper'
                  ? 'Cancelar ajuda'
                  : 'Retirar pedido'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
