import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:wisp_wizz/features/app/settings/settings_screen.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/user/presentation/screens/user_registration_screen.dart';
import 'package:wisp_wizz/features/user/presentation/screens/verification_screen.dart';
import 'package:wisp_wizz/features/app/shared/widgets/slide_page_transition.dart';
import 'package:wisp_wizz/features/app/home/home_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/single_chat_screen.dart';

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

    case ContactsScreen.routeName:
      return SlidePageRoute(widget: const ContactsScreen());

    case SettingScreen.routeName:
      return SlidePageRoute(
          widget: SettingScreen(
        user: routeSettings.arguments as UserModel,
      ));

    case SingleChatScreen.routeName:
      return SlidePageRoute(
          widget: SingleChatScreen(
        user: routeSettings.arguments as UserModel,
      ));

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
