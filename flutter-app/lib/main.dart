import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:wisp_wizz/controller/main_controller.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/services/dependency_injection.dart'
    as dep;
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/app/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/splash_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dep.init();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhoneNumberBloc(),
        ),
        BlocProvider(
          create: (context) => OtpBloc(),
        ),
        BlocProvider(
          create: (context) => dep.sl<AuthBloc>(),
        ),
      ],
      child: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => MainController(),
        ),
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.screenHeight = MediaQuery.of(context).size.height;
    Dimensions.screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: appName,
      onGenerateRoute: (settings) => routesGenerator(settings),
      theme: context.watch<MainController>().themeData,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      home: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return const SplashScreen();
        },
        listener: (context, state) {
          if (state is AuthloggedIn) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          } else if (state is AuthLoggedOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          }
        },
      ),
    );
  }
}
