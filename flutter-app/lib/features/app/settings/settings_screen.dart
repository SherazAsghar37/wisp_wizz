import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'dart:io';
import 'package:wisp_wizz/features/app/constants/screen_constants.dart';
import 'package:wisp_wizz/features/app/shared/widgets/icon_text_button.dart';
import 'package:wisp_wizz/features/app/shared/widgets/input_field.dart';
import 'package:wisp_wizz/features/app/shared/widgets/primary_icon.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = settingScreen;
  final UserModel user;
  const SettingScreen({super.key, required this.user});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void initState() {
    final path = widget.user.image;
    final name = widget.user.name;
    if (path != null) {
      image = File(path);
    }
    nameController.text = name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    double radius = Dimensions.width30 + Dimensions.height30;
    log("print");
    return Scaffold(
        backgroundColor: colorScheme.background,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, Dimensions.height30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10),
                    decoration: BoxDecoration(
                        color: theme.primaryColorLight,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderRadius),
                            bottomRight: Radius.circular(borderRadius))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PrimaryIcon(
                              iconData: arrowBack,
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(
                              width: Dimensions.width10,
                            ),
                            Text(
                              "Settings",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        TextButton(
                          onPressed: () async {
                            XFile? file = await Utils.pickImage();
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
                                backgroundImage: Utils.getFileImage(image)),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        InputField(
                          controller: nameController,
                          prefixInitialIcon: personIcon,
                          hintText: "User name",
                          filledColor: theme.primaryColor.withOpacity(0.2),
                          onSubmitted: () {
                            setState(() {});
                          },
                          onTapOutside: () {
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height15,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width25),
                    child: Column(
                      children: [
                        IconTextButton(
                          icon: lockClosedIcon,
                          text: "Privacy",
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: Dimensions.height15,
                        ),
                        IconTextButton(
                          icon: alertIcon,
                          text: "Notifications",
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: Dimensions.height15,
                        ),
                        IconTextButton(
                          icon: signOutIcon,
                          text: "Logout",
                          onPressed: () {
                            Utils.showAlertDialogue(
                              context,
                              "Are you sure you want to logout?",
                              failureBtnName: "Cancel",
                              sucessBtnName: "Logout",
                              success: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const LogoutEvent());
                              },
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: nameController.text != widget.user.name ||
                (image != null && image!.path != widget.user.image)
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  checkmarkIcon,
                  size: Dimensions.height25,
                ),
              )
            : null);
  }
}
