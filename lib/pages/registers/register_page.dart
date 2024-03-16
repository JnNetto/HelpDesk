import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:provider/provider.dart";
import "../../controllers/register_controller.dart";
import "../../util/AppCollors.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(builder:
        (BuildContext context, RegisterController value, Widget? child) {
      final RegisterController registerController =
          Provider.of<RegisterController>(context);

      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                "Cadastre-se",
                style: TextStyle(
                  color: AppCollors.backgroundCard,
                ),
              ),
              backgroundColor: AppCollors.primaryColor,
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    registerController.nomeController.clear();
                    registerController.emailController.clear();
                    registerController.senhaController.clear();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    lottieAnimation(),
                    Text(
                      "Cadastre",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 40,
                              color: AppCollors.textColorBlue,
                              fontWeight: FontWeight.w500)),
                    ),
                    Text(
                      "Crie sua conta agora mesmo!",
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
                        controller: registerController.nomeController,
                        decoration: InputDecoration(
                            hintText: "Nome",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: AppCollors.textColorBlue),
                            prefixIcon: Icon(
                              Icons.person,
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
                        controller: registerController.emailController,
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
                        controller: registerController.senhaController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "Senha",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: AppCollors.textColorBlue),
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
                      height: 15,
                    ),
                    Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Você é um Helper?",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppCollors.textColorBlue,
                                      fontWeight: FontWeight.bold),
                                )),
                            Switch(
                              value: registerController.isHelper,
                              activeColor: AppCollors.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  registerController.isHelper = value;
                                });
                              },
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          registerController.cadastrarUsuario(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppCollors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text(
                          "Cadastrar",
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
          if (registerController.isLoading)
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

Widget lottieAnimation() {
  return Container(
    margin: const EdgeInsets.only(top: 1, bottom: 10),
    child: Lottie.asset("assets/animations/Animation - 1709649781697.json",
        width: 250, height: 250, fit: BoxFit.fill),
  );
}
