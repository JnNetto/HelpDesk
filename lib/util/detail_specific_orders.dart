import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/controllers/orders_controller.dart';
import 'package:help_desk/util/AppCollors.dart';
import 'package:help_desk/util/dados_gerais.dart';
import '../model/orders.dart';

class DetailSpecificOrders extends StatefulWidget {
  final Orders obj;
  final int index;
  final OrdersController controller;
  final BuildContext context;

  const DetailSpecificOrders({
    required this.obj,
    required this.index,
    required this.controller,
    required this.context,
  });

  @override
  _DetailSpecificOrdersState createState() => _DetailSpecificOrdersState();
}

class _DetailSpecificOrdersState extends State<DetailSpecificOrders> {
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
            TextButton(
              onPressed: () {
                showDeleteConfirmationDialog(
                    context, widget.controller, widget.index);
              },
              child: Text(
                GeneralData.currentUser?.position == 'helper'
                    ? 'Cancelar ajuda'
                    : 'Retirar pedido',
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

void showDeleteConfirmationDialog(
    BuildContext context, OrdersController controller, int index) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja apagar este pedido?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteSpecificOrder(index, context);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );
}
