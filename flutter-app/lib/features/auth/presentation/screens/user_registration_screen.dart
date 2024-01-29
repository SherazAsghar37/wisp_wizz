import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

// ignore: must_be_immutable
class UserRegistrationScreen extends StatefulWidget {
  static const String routeName = serRegistrationScreen;
  UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  File? image;

  TextEditingController nameController = TextEditingController();

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
          padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height10,
              Dimensions.width20, Dimensions.height30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
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
              InputField(controller: nameController, hintText: "User name"),
              SizedBox(
                height: Dimensions.height20,
              ),
              PrimaryButton(
                text: "Submit",
                onTap: () {},
              )
            ],
          ),
        ),
      )),
    );
  }
}

Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  return await picker.pickImage(source: ImageSource.gallery);
}
