import 'package:wisp_wizz/features/app/utils/utils.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';
// import 'package:popover/popover.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = homeScreen;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

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
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthloggedIn) {
                      return Column(
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
                                onPressed: () {
                                  //                          showPopover(
                                  //   context: context,
                                  //   bodyBuilder: (context) => const ListItems(),
                                  //   onPop: () => print('Popover was popped!'),
                                  //   direction: PopoverDirection.bottom,
                                  //   width: 200,
                                  //   height: 400,
                                  //   arrowHeight: 15,
                                  //   arrowWidth: 30,
                                  // );
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      Utils.getUserImage(state.user),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Unknown error occured",
                          style: theme.textTheme.bodyLarge,
                        ),
                      );
                    }
                  },
                ))));
  }
}
