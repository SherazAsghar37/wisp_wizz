import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/verification_screen.dart';
import 'package:wisp_wizz/shared/widgets/slide_page_transition.dart';

Route<dynamic> routesGenerator(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case VerificationScreen.routeName:
      return SlidePageRoute(widget: const VerificationScreen());
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
