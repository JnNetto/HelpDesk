import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HelpDesk",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppCollors.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
                            textStyle:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 13,
                child: Container(
                  padding: EdgeInsets.only(right: 120, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("E-mail utilizado: ",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(GeneralData.currentUser?.email ?? '',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 15),
                            )),
                      ),
                      SizedBox(
                        height: 400,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
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
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            lottieAnimation(),
            SizedBox(
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
            SizedBox(
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
            SizedBox(
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
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppCollors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const Text(
                  "Meus pedidos",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
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
