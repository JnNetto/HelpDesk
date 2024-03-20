import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:help_desk/controllers/register_controller.dart';
import 'package:help_desk/pages/specific_orders/specific_orders_page.dart';
import 'package:provider/provider.dart';
import 'controllers/login_controller.dart';
import 'controllers/orders_controller.dart';
import 'firebase_options.dart';
import 'pages/home/home_page.dart';
import 'pages/login/login_page.dart';
import 'pages/orders/order_page.dart';
import 'pages/registers/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => LoginController(),
            child: const LoginPage(),
          ),
      '/register': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => RegisterController(),
            child: const RegisterPage(),
          ),
      '/home': (BuildContext context) => const Home(),
      '/order': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => OrdersController(),
            child: const OrderPage(),
          ),
      '/specificOrders': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => OrdersController(),
            child: const SpecificOrdersPage(),
          ),
    },
  ));
}
