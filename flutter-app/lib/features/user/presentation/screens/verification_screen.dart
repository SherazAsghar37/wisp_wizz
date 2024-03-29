import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:wisp_wizz/features/user/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/phone-number/phone_number_bloc.dart'
    as phone_number_bloc;
import 'package:wisp_wizz/features/user/presentation/provider/auth_controller.dart';

import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = verificationScreen;
  const VerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final phoneNumberBloc = context.read<phone_number_bloc.PhoneNumberBloc>();
    final otpBloc = context.read<OtpBloc>();
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
                  Row(
                    children: [
                      PrimaryIcon(
                        iconData: arrowBack,
                        onPressed: () {
                          otpBloc.add(const ClearEvent());
                          Navigator.pop(context);
                        },
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
                    "sent to +92${phoneNumberBloc.state.textEditingController.text}",
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
                      (index) => BlocBuilder<OtpBloc, OtpState>(
                        builder: (context, state) {
                          return DigitInputField(
                            focusIndex: state is OtpUpdated
                                ? state.focusFieldNumber
                                : 0,
                            index: index,
                            text: state is OtpUpdated &&
                                    state.otp.length >= index + 1
                                ? state.otp.substring(index, index + 1)
                                : "_",
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Consumer<AuthController>(builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You can request code in ${value.secondsRemaining} seconds ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        TextButton(
                          style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(0))),
                          onPressed: () {
                            if (value.secondsRemaining == 0) {
                              final phoneNumberBlocState =
                                  phoneNumberBloc.state;
                              final String phoneNumber = phoneNumberBlocState
                                  .textEditingController.text;
                              final String countryCode =
                                  phoneNumberBlocState.countryCode;
                              context.read<auth_bloc.AuthBloc>().add(
                                  auth_bloc.SendCodeEvent(
                                      phoneNumber: countryCode + phoneNumber));
                              value.startTimer();
                            } else {
                              BotToast.showText(
                                  text:
                                      "kindly wait for ${value.secondsRemaining} seconds",
                                  contentColor: theme.primaryColorLight,
                                  textStyle: theme.textTheme.bodyMedium!);
                            }
                          },
                          child: Text(
                            "Resend",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.primaryColor),
                          ),
                        )
                      ],
                    );
                  }),
                ],
              ),
              Column(
                children: [
                  BlocConsumer<auth_bloc.AuthBloc, auth_bloc.AuthState>(
                    builder: (context, state) {
                      if (state is auth_bloc.AuthVerifyingOTP ||
                          state is auth_bloc.AuthGettingUser ||
                          state is auth_bloc.AuthSendingCode) {
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
                            final String otp = otpBloc.state.otp;
                            context
                                .read<auth_bloc.AuthBloc>()
                                .add(auth_bloc.VerifyOTPEvent(otp: otp));
                          },
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is auth_bloc.AuthOTPVerified) {
                        context
                            .read<auth_bloc.AuthBloc>()
                            .add(auth_bloc.GetUserEvent(
                              phoneNumber: phoneNumberBloc.state.countryCode +
                                  phoneNumberBloc
                                      .state.textEditingController.text,
                            ));
                      } else if (state is auth_bloc.AuthUserFound ||
                          state is auth_bloc.AuthUserNotFound) {
                        context.read<AuthController>().cancelTimer();
                        Navigator.pushReplacementNamed(
                            context, UserRegistrationScreen.routeName);
                      } else if (state is auth_bloc.AuthOTPVerificationFailed) {
                        BotToast.showText(
                            text: state.message,
                            contentColor: theme.primaryColorLight,
                            textStyle: theme.textTheme.bodyMedium!);
                      } else if (state is auth_bloc.AuthFailedToGetUser) {
                        BotToast.showText(
                            text: state.message,
                            contentColor: theme.primaryColorLight,
                            textStyle: theme.textTheme.bodyMedium!);
                      }
                    },
                  ),
                  SizedBox(height: Dimensions.height20),
                  NumberPad(
                    onPressed: (int num) {
                      final otpBloc = BlocProvider.of<OtpBloc>(context);
                      if (num >= 0) {
                        otpBloc.add(InsertEvent(
                          value: num,
                        ));
                      } else if (num == -1) {
                        otpBloc.add(const BackspaceEvent());
                      } else if (num == -2) {
                        otpBloc.add(const ClearEvent());
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
}
