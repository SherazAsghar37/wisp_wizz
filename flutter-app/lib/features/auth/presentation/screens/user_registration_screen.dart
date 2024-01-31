import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

// ignore: must_be_immutable
class UserRegistrationScreen extends StatefulWidget {
  static const String routeName = serRegistrationScreen;
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File? image;

  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthUserFound) {
      final path = state.user.image;
      final name = state.user.name;
      if (path != null) {
        image = File(path);
      }
      nameController.text = name;
    }
    super.initState();
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
                        XFile? file = await pickImage();
                        if (file != null) {
                          setState(() {
                            image = File(file.path);
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: radius,
                        backgroundColor: theme.primaryColor,
                        child: CircleAvatar(
                            radius: radius - 5,
                            backgroundImage: image == null
                                ? Image.asset(
                                    "images/profile.png",
                                    fit: BoxFit.cover,
                                  ).image
                                : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ).image),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    InputField(
                        controller: nameController, hintText: "User name"),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    state is AuthloggingIn
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
                            onTap: () async {
                              await FileManager.createMediaFolder();
                              await FileManager.createProfilePictureFolder();
                              String? path;
                              if (image != null) {
                                path = await FileManager.saveProfilePicture(
                                    image!);
                              }

                              final phoneNumberBloc =
                                  // ignore: use_build_context_synchronously
                                  context.read<PhoneNumberBloc>().state;
                              // ignore: use_build_context_synchronously
                              context.read<AuthBloc>().add(LoginEvent(
                                  phoneNumber: phoneNumberBloc
                                      .textEditingController.text,
                                  countryCode: phoneNumberBloc.countryCode,
                                  name: nameController.text.isEmpty
                                      ? null
                                      : nameController.text,
                                  image: path));
                            },
                          )
                  ],
                );
              },
              listener: (context, state) {
                if (state is AuthloggedIn) {
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

Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  return await picker.pickImage(source: ImageSource.gallery);
}
