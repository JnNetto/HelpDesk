import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_desk/src/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import '../../util/AppCollors.dart';
import '../../util/dados_gerais.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Map<String, List> opcoes = {
      'titulo': [
        "Editar",
        'Histórico',
        'Instruções',
        'Sobre',
        'Encerrar sessão'
      ],
      'icone': [
        Icons.edit,
        Icons.history,
        Icons.find_in_page_sharp,
        Icons.help_outline,
        Icons.exit_to_app
      ],
      'rotas': [
        '/editProfile',
        '/historicOrders',
        '/instructions',
        '/about',
        ''
      ]
    };

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "HelpDesk",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppCollors.primaryColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: drawer(context, opcoes),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                lottieAnimation(),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'HelpDesk',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 40,
                          color: AppCollors.textColorBlue,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Seja bem vindo!",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 20,
                    color: AppCollors.textColorBlue,
                  )),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/order");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppCollors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "Pedidos gerais",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/specificOrders");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppCollors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      GeneralData.currentUser?.position == 'helper'
                          ? "Pedidos aceitos"
                          : "Meus pedidos",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget lottieAnimation() {
  return Container(
    margin: const EdgeInsets.only(top: 1, bottom: 10),
    child: Lottie.asset("assets/animations/Computer.json",
        width: 250, height: 250, fit: BoxFit.fill),
  );
}
