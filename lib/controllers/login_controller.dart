import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../exceptions/failure.dart';
import '../model/orders.dart';
import '../model/users.dart';
import '../repository/orders_repository.dart';
import '../repository/users_repository.dart';
import '../util/dados_gerais.dart';

class LoginController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool _isLoading = false;
  GlobalKey<State> modalBarrierKey = GlobalKey<State>();
  bool get isLoading => _isLoading;

  Future<void> efetuaLogin({
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      final UsersRepository userRepository = UsersRepository();
      final OrdersRepository ordersRepository = OrdersRepository();
      Users? user = (await userRepository.getUserByEmail(emailController.text));

      List<Orders>? listOrders = (await ordersRepository.getAllOrders());
      if (user != null) {
        GeneralData.currentUser = user;
        GeneralData.currentorders = listOrders;
        const SnackBar snackBar = SnackBar(
          content: Text("Login efetuado com sucesso!!"),
          duration: Duration(seconds: 5),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, "/home");
        _isLoading = false;
        notifyListeners();
      } else {
        const SnackBar snackBar = SnackBar(
          content: Text("Usuário não encontrado"),
          duration: Duration(seconds: 5),
        );
        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      Failure.showErrorDialog(context, e);
    }
  }
}
