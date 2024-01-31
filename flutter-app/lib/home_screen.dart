import 'package:wisp_wizz/features/app/utils/utils.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/screens/login_screen.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = homeScreen;
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  Future<int?> _showPopupMenu(ThemeData theme, ColorScheme colorScheme) async {
    int? val;
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 100),
      color: colorScheme.background,
      items: [
        PopupMenuItem(
          value: 1,
          child: Text(
            "profile",
            style: theme.textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "settings",
            style: theme.textTheme.bodyMedium,
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "logout",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      val = value;
    });
    return val;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.width15,
                  Dimensions.height15,
                  Dimensions.width15,
                  Dimensions.height10,
                ),
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
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: Dimensions.height40,
                                    width: Dimensions.screenWidth / 1.4,
                                    child: InputField(
                                      controller: searchController,
                                      hintText: "Search",
                                      prefixInitialIcon: searchIcon,
                                      prefixFinalIcon: arrowBack,
                                    )),
                                TextButton(
                                  onPressed: () async {
                                    final int? selectedOption =
                                        await _showPopupMenu(
                                            theme, colorScheme);
                                    switch (selectedOption) {
                                      case 1:
                                        break;
                                      case 2:
                                        break;
                                      case 3:
                                        // ignore: use_build_context_synchronously
                                        Utils.showAlertDialogue(
                                          context,
                                          theme,
                                          colorScheme,
                                          "Are you sure you want to logout?",
                                          failureBtnName: "Cancel",
                                          sucessBtnName: "Logout",
                                          success: () {
                                            context
                                                .read<AuthBloc>()
                                                .add(const LogoutEvent());
                                          },
                                        );
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        Utils.getUserImage(widget.user),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ))));
  }
}
