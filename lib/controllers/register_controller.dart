import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../exceptions/failure.dart';
import '../model/new_user.dart';

class RegisterController extends ChangeNotifier {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool isHelper = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  void cadastrarUsuario(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
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

      if (isHelper) {
        await db.collection('Usuários').add(
            {"nome": user.nome, "email": user.email, "ocupacao": "helper"});
      } else {
        await db.collection('Usuários').add(
            {"nome": user.nome, "email": user.email, "ocupacao": "cliente"});
      }

      _isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, "/login");
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      Failure.showErrorDialog(context, e);
    }
  }
}
