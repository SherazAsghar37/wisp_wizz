import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisp_wizz/controller/main_controller.dart';
import 'package:wisp_wizz/controller/auth_controller.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => MainController(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthController(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.screenHeight = MediaQuery.of(context).size.height;
    Dimensions.screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Wip Wiz',
      onGenerateRoute: (settings) => routesGenerator(settings),
      theme: context.watch<MainController>().themeData,
      home: const LoginScreen(),
    );
  }
}
