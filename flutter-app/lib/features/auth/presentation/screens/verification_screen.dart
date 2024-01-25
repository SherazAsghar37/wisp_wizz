import 'package:bot_toast/bot_toast.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:wisp_wizz/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart'
    as phone_number_bloc;
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/home_screen.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = verificationScreen;
  const VerificationScreen({super.key});
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
                    "sent to +92${context.read<phone_number_bloc.PhoneNumberBloc>().state.textEditingController.text}",
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
                            focusIndex: state.focusFieldNumber,
                            index: index,
                            text: state.otp.length >= index + 1
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
                  BlocConsumer<auth_bloc.AuthBloc, auth_bloc.AuthState>(
                    builder: (context, state) {
                      DebugHelper.printWarning(state.runtimeType.toString());
                      if (state is auth_bloc.AuthVerifyingOTP) {
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
                            final String otp =
                                context.read<OtpBloc>().state.otp;
                            context
                                .read<auth_bloc.AuthBloc>()
                                .add(auth_bloc.VerifyOTPEvent(otp: otp));
                          },
                        );
                      }
                    },
                    listener: (context, state) {
                      if (state is auth_bloc.AuthOTPVerified) {
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName);
                      } else if (state is auth_bloc.AuthOTPVerificationFailed) {
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
