import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisp_wizz/core/dimensions.dart';
import 'package:wisp_wizz/features/auth/controllers/auth_controller.dart';
import 'package:wisp_wizz/features/auth/screens/verification_screen.dart';
import 'package:wisp_wizz/features/auth/widgets/input_field.dart';
import 'package:wisp_wizz/features/auth/widgets/number_pad.dart';
import 'package:wisp_wizz/shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double scaleFactor = 1;
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final authController = Provider.of<AuthController>(context);
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
                Text(
                  "Enter Your Phone Number",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                SizedBox(
                  height: Dimensions.height45,
                  child: Row(
                    children: [
                      Container(
                        height: Dimensions.height50,
                        width: Dimensions.width80,
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10),
                        decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimensions.height10),
                                bottomLeft:
                                    Radius.circular(Dimensions.height10))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: Dimensions.height20,
                              width: Dimensions.width20,
                              child: Flag.fromCode(FlagsCode.PK,
                                  flagSize: FlagSize.size_4x3),
                            ),
                            Text(
                              "+92",
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: Dimensions.width1,
                        color: colorScheme.background,
                      ),
                      Expanded(
                        child: InputField(
                            controller: context
                                .watch<AuthController>()
                                .numberController),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Text(
                  "In order to verify this number, We will send you a one time password to this number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.primary),
                ),
              ],
            ),
            Column(
              children: [
                PrimaryButton(
                  text: "Submit",
                  onTap: () {
                    Navigator.pushNamed(context, VerificationScreen.routeName);
                  },
                ),
                // Transform.scale(
                //   scale: scaleFactor,
                //   child: Visibility(
                //     visible: isVisible,
                //     child: PrimaryButton(
                //       text: "Submit",
                //       onTap: () {
                //         // scale();
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(height: Dimensions.height20),
                NumberPad(
                  controller: authController.numberController,
                  onPressed: (int num) {
                    if (num >= 0) {
                      authController.insertNumber(
                          authController.numberController, num.toString());
                    } else if (num == -1) {
                      authController.backSpace(authController.numberController);
                    } else {
                      authController.clearAll(authController.numberController);
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

//   scale() async {
//     setState(() {
//       isVisible = true;
//     });
//     for (var i = 0; i < 200; i++) {
//       Future.delayed(
//         const Duration(milliseconds: 2),
//         () {
//           setState(() {
//             scaleFactor += 0.15;
//           });
//         },
//       );
//     }
//     Navigator.pushNamed(context, VerificationScreen.routeName).then((value) {
//       for (var i = 0; i < 200; i++) {
//         Future.delayed(
//           const Duration(milliseconds: 2),
//           () {
//             setState(() {
//               scaleFactor -= 0.15;
//             });
//           },
//         );
//       }
//       setState(() {
//         isVisible = true;
//       });
//     });
//   }
}
