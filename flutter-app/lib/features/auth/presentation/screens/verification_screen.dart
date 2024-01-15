import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/constants/icons_constants.dart';
import 'package:wisp_wizz/features/app/constants/screen_constants.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/controller/auth_controller.dart';
import 'package:wisp_wizz/features/auth/presentation/widgets/digit_input_field.dart';
import 'package:wisp_wizz/features/auth/presentation/widgets/number_pad.dart';
import 'package:wisp_wizz/shared/widgets/primary_button.dart';
import 'package:wisp_wizz/shared/widgets/primary_icon.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = verificationScreen;
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authController = Provider.of<AuthController>(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height30,
            Dimensions.width20, Dimensions.height30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    PrimaryIcon(
                      iconData: arrowBack,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(
                  "Enter Verification Code",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: Dimensions.height5,
                ),
                Text(
                  "sent to +92${authController.numberController.text}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.primary),
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    verificationCodeLength,
                    (index) => DigitInputField(
                      focusIndex: authController.codeInputFocus,
                      index: index,
                      text:
                          authController.codeController.text.length >= index + 1
                              ? authController.codeController.text
                                  .substring(index, index + 1)
                              : "_",
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Did'nt receive code?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Resend",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                PrimaryButton(
                  text: "Submit",
                  onTap: () {},
                ),
                SizedBox(height: Dimensions.height20),
                NumberPad(
                  controller: authController.codeController,
                  onPressed: (int num) {
                    if (num >= 0 &&
                        authController.codeController.text.length <= 5) {
                      authController.insertNumber(
                          authController.codeController, num.toString(),
                          inputfocus: authController.codeInputFocus);
                    } else if (num == -1) {
                      authController.backSpace(authController.codeController,
                          inputfocus: authController.codeInputFocus);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
