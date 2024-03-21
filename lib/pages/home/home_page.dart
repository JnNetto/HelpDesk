import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        drawer: Drawer(
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    color: AppCollors.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          minRadius: 50,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          GeneralData.currentUser?.name ?? '',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 30, color: Colors.white)),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 13,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text("E-mail utilizado: ",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                        Text(GeneralData.currentUser?.email ?? '',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 15),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Função: ",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                        Text(
                            GeneralData.currentUser?.position?.toUpperCase() ??
                                '',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 15),
                            )),
                        const SizedBox(
                          height: 350,
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmar Logout'),
                                    content: const Text(
                                        'Tem certeza que deseja sair da conta?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.remove('list');
                                          Navigator.of(context).pop();
                                          Navigator.pushNamed(
                                              context, "/login");
                                        },
                                        child: const Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text("Encerrar sessão",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: AppCollors.primaryColor),
                                )))
                      ],
                    ),
                  ))
            ],
          ),
        ),
        body: Container(
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
