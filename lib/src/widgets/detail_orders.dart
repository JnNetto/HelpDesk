import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/src/controllers/orders_controller.dart';
import 'package:help_desk/src/util/AppCollors.dart';
import 'package:help_desk/src/util/dados_gerais.dart';

import '../model/orders.dart';

class DetailOrders extends StatefulWidget {
  final Orders obj;
  final int index;
  final OrdersController controller;

  const DetailOrders({
    super.key,
    required this.obj,
    required this.index,
    required this.controller,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DetailOrdersState createState() => _DetailOrdersState();
}

class _DetailOrdersState extends State<DetailOrders> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Center(
            child: Text(
              widget.obj.titulo ?? '',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppCollors.textColorBlue,
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nome: ${widget.obj.autor}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppCollors.textColorBlue,
                  ),
                ),
              ),
              Visibility(
                visible: widget.obj.helperQueAceitou != '',
                child: Text(
                  "Helper: ${widget.obj.helperQueAceitou}",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppCollors.textColorBlue,
                    ),
                  ),
                ),
              ),
              Text(
                "Data: ${widget.controller.dataFormatada(widget.obj.dataDoChamado?.toDate() ?? DateTime.now())}",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppCollors.textColorBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.obj.descricao ?? '',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: AppCollors.textColorBlue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: GeneralData.currentUser?.position == 'helper' &&
                  widget.obj.status == false,
              child: TextButton(
                onPressed: () {
                  widget.controller.acceptOrder(context, widget.index);
                  Navigator.pop(context);
                },
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
}
