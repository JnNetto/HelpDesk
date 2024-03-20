import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_controller.dart';
import '../../util/AppCollors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (BuildContext context, LoginController value, Widget? child) {
        final LoginController loginController =
            Provider.of<LoginController>(context);

        void efetuaLogin() async {
          await loginController.efetuaLogin(
            context: context,
          );
        }

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  "Acesse nosso aplicativo!",
                  style: TextStyle(
                    color: AppCollors.backgroundCard,
                  ),
                ),
                backgroundColor: AppCollors.primaryColor,
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      lottieAnimation(),
                      Text(
                        "HelpDesk",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 40,
                                color: AppCollors.textColorBlue,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text(
                        "O seu aplicativo de HelpDesk!",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: AppCollors.textColorBlue,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        color: AppCollors.backgroundCard,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: loginController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: AppCollors.textColorBlue),
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppCollors.primaryColor,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        color: AppCollors.backgroundCard,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: loginController.senhaController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Senha",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: AppCollors.textColorBlue),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppCollors.primaryColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: AppCollors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.group_add,
                                  color: AppCollors.primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/register");
                                  },
                                  child: Text(
                                    "Criar uma conta",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: AppCollors.textColorBlue)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: AppCollors.primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Text(
                                    "Recuperar senha",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: AppCollors.textColorBlue)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: efetuaLogin,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppCollors.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                            "Entrar",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (loginController.isLoading)
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
      },
    );
  }
}

Widget lottieAnimation() {
  return Container(
    margin: const EdgeInsets.only(top: 1, bottom: 10),
    child: Lottie.asset("assets/animations/Animation - 1709746006005.json",
        width: 250, height: 250, fit: BoxFit.fill),
  );
}
