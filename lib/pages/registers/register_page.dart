import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";

import "../../exceptions/failure.dart";
import "../../model/new_user.dart";
import "../../util/AppCollors.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool obscureText = true;
  bool isHelper = false;

  void validadarDados(String nome, String email, String senha) {
    String msgErro = '';

    if (nome.isNotEmpty || email.isNotEmpty || senha.isNotEmpty) {
      if (email.contains("@") && email.contains(".com")) {
        if (senha.length > 8 || !senha.contains(" ")) {
        } else {
          msgErro = "Senha precisa ter no mínimo 8 caracteres sem espaçamentos";
          print(msgErro);
        }
      } else {
        msgErro = "Endereço de email tem estrutura incorreta";
        print(msgErro);
      }
    } else {
      msgErro = "Há campos vazios";
      print(msgErro);
    }
  }

  void cadastrarUsuario(bool helper) async {
    try {
      String nome = nomeController.text;
      String email = emailController.text;
      String senha = senhaController.text;

      NewUser user = NewUser();
      user.nome = nome;
      user.email = email;
      user.senha = senha;
      validadarDados(user.nome, user.email, user.senha);

      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.senha);

      const SnackBar snackBar = SnackBar(
        content: Text("Cadastrado com sucesso!!"),
        duration: Duration(seconds: 5),
      );
      FirebaseFirestore db = FirebaseFirestore.instance;

      if (helper) {
        await db.collection('Usuários').add(
            {"nome": user.nome, "email": user.email, "ocupacao": "helper"});
      } else {
        await db.collection('Usuários').add(
            {"nome": user.nome, "email": user.email, "ocupacao": "cliente"});
      }

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, "/login");
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Failure.showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              nomeController.clear();
              emailController.clear();
              senhaController.clear();
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
                  controller: nomeController,
                  decoration: InputDecoration(
                      hintText: "Nome",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppCollors.textColorBlue),
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
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppCollors.textColorBlue),
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
                  controller: senhaController,
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
                        value: isHelper,
                        activeColor: AppCollors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            isHelper = value;
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
                    cadastrarUsuario(isHelper);
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
    );
  }
}

Widget lottieAnimation() {
  return Container(
    margin: const EdgeInsets.only(top: 1, bottom: 10),
    child: Lottie.asset("assets/animations/Animation - 1709649781697.json",
        width: 250, height: 250, fit: BoxFit.fill),
  );
}
