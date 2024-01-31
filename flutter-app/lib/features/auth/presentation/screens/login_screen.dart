import 'package:bot_toast/bot_toast.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = loginScreen;
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// String countryCode = dCountryCode;
String flagCode = dFlagCode;

class _LoginScreenState extends State<LoginScreen> {
  // double scaleFactor = 1;
  // bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(Dimensions.width20, Dimensions.height10,
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
                        MaterialButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => showCountryPicker(
                              context: context,
                              countryListTheme: countryListThemeData(theme),
                              onSelect: (Country country) {
                                setState(() {
                                  flagCode = country.countryCode;
                                  RegExpMatch? match = contryCodeRegex
                                      .firstMatch(country.displayName);

                                  context.read<PhoneNumberBloc>().add(
                                      InsertCountryCodeEvent(
                                          countryCode: match != null
                                              ? match.group(1)!
                                              : dCountryCode));
                                });
                              }),
                          child: Container(
                            height: Dimensions.height50,
                            width: Dimensions.width105,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10),
                            decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(Dimensions.height10),
                                    bottomLeft:
                                        Radius.circular(Dimensions.height10))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: Dimensions.height20,
                                  width: Dimensions.width20,
                                  child: Flag.fromString(flagCode),
                                ),
                                SizedBox(
                                  width: Dimensions.width2,
                                ),
                                BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
                                  builder: (context, state) => Text(
                                    state.countryCode,
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Icon(
                                  dropDownIcon,
                                  color: blackColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Dimensions.width1,
                          color: colorScheme.background,
                        ),
                        BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
                          builder: (context, state) {
                            return Expanded(
                              child: InputField(
                                  hintText: "0123456789",
                                  leftBorder: Radius.zero,
                                  readonly: true,
                                  inputType: TextInputType.none,
                                  controller: state.textEditingController),
                            );
                          },
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
                  BlocConsumer<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthSendingCode) {
                        return PrimaryButton(
                          onTap: () {},
                          widget: SizedBox(
                            width: Dimensions.height30,
                            child: CircularProgressIndicator(
                              color: colorScheme.background,
                            ),
                          ),
                        );
                      } else {
                        return PrimaryButton(
                          text: "Submit",
                          onTap: () {
                            final phoneNumberBlocState =
                                context.read<PhoneNumberBloc>().state;
                            final String phoneNumber =
                                phoneNumberBlocState.textEditingController.text;
                            final String countryCode =
                                phoneNumberBlocState.countryCode;
                            context.read<AuthBloc>().add(SendCodeEvent(
                                countryCode: countryCode,
                                phoneNumber: phoneNumber));
                          },
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is AuthCodeSent) {
                        Navigator.pushNamed(
                            context, VerificationScreen.routeName);
                      } else if (state is AuthOTPVerified) {
                        Navigator.pushReplacementNamed(
                            context, VerificationScreen.routeName);
                      } else if (state is AuthCodeSentFailed) {
                        BotToast.showText(
                            text: state.message,
                            contentColor: theme.primaryColorLight,
                            textStyle: theme.textTheme.bodyMedium!);
                      }
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
                    onPressed: (int num) {
                      final phoneNumberBloc =
                          BlocProvider.of<PhoneNumberBloc>(context);
                      if (num >= 0) {
                        phoneNumberBloc.add(InsertEvent(value: num));
                      } else if (num == -1) {
                        phoneNumberBloc.add(const BackspaceEvent());
                      } else {
                        phoneNumberBloc.add(const ClearEvent());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
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
