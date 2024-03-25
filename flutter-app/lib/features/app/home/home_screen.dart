import 'dart:developer';

import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/settings/settings_screen.dart';
import 'package:wisp_wizz/features/app/shared/widgets/custom_tab_bar.dart';
import 'package:wisp_wizz/features/app/socket/socket_manager.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/calls/presentation/screens/calls_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/chats_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/groups_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = homeScreen;
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  final String notifications = "5";
  late List<Widget> tabScreens = [
    const ChatsScreen(),
    const GroupsScreen(),
    const CallsScreen(),
  ];

  final List<IconData> tabIcons = [
    personalChatIcon,
    groupChatIcon,
    callRegularIcon
  ];
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabScreens.length);
    final chatBloc = context.read<UserChatsBloc>();
    chatBloc.add(FetchUserChatsEvent(chats: const [], userId: widget.user.id));
    WebSocketManager.socket.on("message${widget.user.id}", (data) {
      log("received");
      context.read<MessageBloc>().add(ReceivedMessageEvent(
          senderId: data["senderId"],
          recipientId: data["recipientId"],
          message: data["message"],
          chatId: data["chatId"],
          repliedToId: data["repliedToId"],
          repliedMessage: data["repliedMessage"],
          isChatClosed: true,
          messageId: data["messageId"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double radius = Dimensions.height9 + Dimensions.width9;

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.width15,
                    Dimensions.height5, Dimensions.width15, 0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoggedOut) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false);
                    }

                    if (state is AuthFailedToLogout) {
                      BotToast.showText(
                          text: state.message,
                          contentColor: theme.primaryColorLight,
                          textStyle: theme.textTheme.bodyMedium!);
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        state is AuthLoggingout
                            ? Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                              )
                            : const SizedBox(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // DebugHelper.printWarning("Dropping database");
                                // await SqfliteManager.dropdb();
                                SqfliteManager.fetchChats(widget.user.id, 0);
                              },
                              child: Text(
                                appName,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: Dimensions.height35,
                                    width: Dimensions.screenWidth / 1.4,
                                    child: InputField(
                                      controller: searchController,
                                      hintText: "Search",
                                      prefixInitialIcon: searchIcon,
                                      prefixFinalIcon: arrowBack,
                                      iconSize: Dimensions.height18,
                                      textStyle: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontSize: Dimensions.height15),
                                      contentPadding: const EdgeInsets.all(0),
                                    )),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                            context, SettingScreen.routeName,
                                            arguments: state is AuthloggedIn
                                                ? state.user
                                                : widget.user)
                                        .then((value) {
                                      setState(() {
                                        DebugHelper.printWarning("back");
                                      });
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        theme.colorScheme.background,
                                    radius: radius,
                                    backgroundImage: Utils.getUserImage(
                                        state is AuthloggedIn
                                            ? state.user
                                            : widget.user),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: Dimensions.height10),
                            CustomTabBar(
                                tabs: tabIcons,
                                tabController: tabController,
                                notifications: const [true, false, false]),
                            Expanded(
                                child: TabBarView(
                              controller: tabController,
                              children: tabScreens,
                            ))
                          ],
                        ),
                      ],
                    );
                  },
                ))));
  }
}
