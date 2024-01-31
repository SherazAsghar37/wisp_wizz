import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/user_registration_screen.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/verification_screen.dart';
import 'package:wisp_wizz/features/app/shared/widgets/slide_page_transition.dart';
import 'package:wisp_wizz/home_screen.dart';

Route<dynamic> routesGenerator(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case VerificationScreen.routeName:
      return SlidePageRoute(widget: const VerificationScreen());
    case HomeScreen.routeName:
      return SlidePageRoute(
          widget: HomeScreen(
        user: routeSettings.arguments as UserModel,
      ));
    case UserRegistrationScreen.routeName:
      return SlidePageRoute(widget: const UserRegistrationScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Screen not found"),
          ),
        ),
      );
  }
}
