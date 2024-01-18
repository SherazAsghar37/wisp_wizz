import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wisp_wizz/controller/main_controller.dart';
import 'package:wisp_wizz/controller/auth_controller.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
          providers: [
        BlocProvider(
          create: (context) => PhoneNumberBloc(),
        ),
        BlocProvider(
          create: (context) => OtpBloc(),
        ),
      ],
          child: MultiProvider(providers: [
            ChangeNotifierProvider(
              create: (context) => MainController(),
            ),
            ChangeNotifierProvider(
              create: (context) => AuthController(),
            ),
          ], child: const MyApp()))
      // (providers: [
      //   ChangeNotifierProvider(
      //     create: (context) => MainController(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (context) => AuthController(),
      //   )
      // ], child: const MyApp())
      );
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
