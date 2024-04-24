import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/phone-number/phone_number_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/socket/socket_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

// ignore: must_be_immutable
class UserRegistrationScreen extends StatefulWidget {
  static const String routeName = userRegistrationScreen;
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  // File? image;
  Uint8List? image;
  String? imageUrl;

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthUserFound) {
      imageUrl = state.user.image;
      final name = state.user.name;
      nameController.text = name;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    double radius = Dimensions.width30 + Dimensions.height30;
    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(Dimensions.width20,
                Dimensions.height10, Dimensions.width20, Dimensions.height30),
            child: BlocConsumer<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Info",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "Please provide your name and an optional profile picture",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    TextButton(
                        onPressed: () async {
                          XFile? file = await Utils.pickImage();

                          if (file != null) {
                            image = await file.readAsBytes();
                            setState(() {});
                          }
                        },
                        child: CircleAvatar(
                          radius: radius,
                          backgroundColor: theme.primaryColor,
                          child: image == null
                              ? CachedNetworkImage(
                                  imageUrl: baseUrl + (imageUrl ?? ""),
                                  key: ValueKey(Random().nextInt(100)),
                                  placeholder: (context, url) => CircleAvatar(
                                      radius: radius - 5,
                                      backgroundImage:
                                          Image.asset("images/profile.png")
                                              .image),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          radius: radius - 5,
                                          backgroundImage:
                                              Image.asset("images/profile.png")
                                                  .image),
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                        radius: radius - 5,
                                        backgroundImage: imageProvider);
                                  },
                                )
                              : CircleAvatar(
                                  radius: radius - 5,
                                  backgroundImage:
                                      Utils.getUserImageFromUint8List(
                                    image,
                                  )),
                        )),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    InputField(
                        controller: nameController, hintText: "User name"),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    state is AuthloggingIn || state is AuthUpdatingUser
                        ? PrimaryButton(
                            onTap: () {},
                            widget: SizedBox(
                              width: Dimensions.height30,
                              child: CircularProgressIndicator(
                                color: colorScheme.background,
                              ),
                            ),
                          )
                        : PrimaryButton(
                            text: "Submit",
                            onTap: () {
                              imageCache.clear();
                              imageCache.clearLiveImages();

                              if (state is AuthUserFound) {
                                context.read<AuthBloc>().add(UpdateUserEvent(
                                      id: state.user.id,
                                      name: nameController.text.isEmpty
                                          ? null
                                          : nameController.text,
                                      image: image,
                                    ));
                              } else {
                                final phoneNumberBloc =
                                    context.read<PhoneNumberBloc>().state;
                                context.read<AuthBloc>().add(LoginEvent(
                                      phoneNumber: phoneNumberBloc.countryCode +
                                          phoneNumberBloc
                                              .textEditingController.text,
                                      name: nameController.text.trim().isEmpty
                                          ? null
                                          : nameController.text.trim(),
                                      image: image,
                                    ));
                              }
                            })
                  ],
                );
              },
              listener: (context, state) {
                if (state is AuthloggedIn) {
                  context
                      .read<SocketBloc>()
                      .add(ConnectSocketEvent(state.user.id));

                  Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                      arguments: state.user);
                }

                if (state is AuthloginFailed) {
                  BotToast.showText(
                      text: state.message,
                      contentColor: theme.primaryColorLight,
                      textStyle: theme.textTheme.bodyMedium!);
                }
              },
            )),
      )),
    );
  }
}
