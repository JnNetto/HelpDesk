import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:help_desk/src/controllers/edit_profile_controller.dart';
import 'package:help_desk/src/controllers/register_controller.dart';
import 'package:help_desk/src/pages/historic_orders/historic_orders.dart';
import 'package:help_desk/src/pages/specific_orders/specific_orders_page.dart';
import 'package:provider/provider.dart';
import 'src/controllers/login_controller.dart';
import 'src/controllers/orders_controller.dart';
import 'firebase_options.dart';
import 'src/pages/edit/edit_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/pages/login/login_page.dart';
import 'src/pages/orders/order_page.dart';
import 'src/pages/registers/register_page.dart';

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
      '/historicOrders': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => OrdersController(),
            child: const HistoricOrdersPage(),
          ),
      '/editProfile': (BuildContext context) => ChangeNotifierProvider(
            create: (context) => EditProfileController(),
            child: const EditPage(),
          ),
    },
  ));
}
