import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/AppCollors.dart';
import '../util/dados_gerais.dart';

Widget drawer(BuildContext context, Map opcoes) {
  List listTitulo = opcoes['titulo'];
  List listIcones = opcoes['icone'];
  List listRotas = opcoes['rotas'];

  return Drawer(
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
                            const TextStyle(fontSize: 30, color: Colors.white)),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 13,
            child: ListView.builder(
                itemCount: listTitulo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      if (listRotas[index] == '/editProfile') {
                        Navigator.pushNamed(context, listRotas[index]);
                      }
                      if (listRotas[index] == '/historicOrders') {
                        Navigator.pushNamed(context, listRotas[index]);
                      }
                      if (listRotas[index] == '') {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('list');

                        // Redirecionar o usuário para a tela de login
                        Navigator.of(context).pop(); // Fechar o AlertDialog
                        Navigator.pushNamed(context, "/login");
                      }
                    },
                    contentPadding: const EdgeInsets.only(bottom: 5, left: 20),
                    title: Text(
                      listTitulo[index],
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppCollors.textColorBlue)),
                    ),
                    leading: Icon(
                      listIcones[index],
                      color: AppCollors.primaryColor,
                    ),
                  );
                }))
      ],
    ),
  );
}


// showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Confirmar Logout'),
//                               content: const Text(
//                                   'Tem certeza que deseja sair da conta?'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('Cancelar'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () async {
//                                     final SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                     await prefs.remove('list');
//                                     // ignore: use_build_context_synchronously
//                                     Navigator.of(context).pop();
//                                     Navigator.pushNamed(
//                                         // ignore: use_build_context_synchronously
//                                         context,
//                                         "/login");
//                                   },
//                                   child: const Text('Confirmar'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
