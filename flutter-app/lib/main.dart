import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:wisp_wizz/controller/main_controller.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/services/dependency_injection.dart'
    as dep;
import 'package:wisp_wizz/features/app/helper/dimensions.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/chat-bloc/chat_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/current-chat-bloc/current_chat_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/contacts/presentation/bloc/contact_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/phone-number/phone_number_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/socket/socket_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/provider/auth_controller.dart';
import 'package:wisp_wizz/features/user/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/app/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wisp_wizz/features/user/presentation/screens/splash_screen.dart';
import 'package:wisp_wizz/features/app/home/home_screen.dart';
import 'features/app/config/firebase_options.dart';

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
        BlocProvider(
          create: (context) => dep.sl<ContactBloc>(),
        ),
        BlocProvider(
          create: (context) => dep.sl<ChatBloc>(),
        ),
        BlocProvider(
          create: (context) => dep.sl<MessageBloc>(),
        ),
        BlocProvider(
          create: (context) => dep.sl<UserChatsBloc>(),
        ),
        BlocProvider(
          create: (context) => dep.sl<CurrentChatBloc>(),
        ),
        BlocProvider(
          create: (context) => dep.sl<SocketBloc>(),
        ),
      ],
      child: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => MainController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
      ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.screenHeight = MediaQuery.of(context).size.height;
    Dimensions.screenWidth = MediaQuery.of(context).size.width;
    final theme = context.watch<MainController>().themeData;
    return MaterialApp(
      title: appName,
      onGenerateRoute: (settings) => routesGenerator(settings),
      theme: theme,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      home: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return const SplashScreen();
        },
        listener: (context, state) {
          if (state is AuthloggedIn) {
            context.read<SocketBloc>().add(ConnectSocketEvent(state.user.id));
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false,
                arguments: state.user);
          } else if (state is AuthLoggedOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
          } else if (state is AuthInitializationFailed) {
            BotToast.showText(
                text: state.message,
                contentColor: theme.primaryColorLight,
                textStyle: theme.textTheme.bodyMedium!);
          }
        },
      ),
    );
  }
}
