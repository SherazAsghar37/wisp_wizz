import 'package:wisp_wizz/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/phone-number/phone_number_bloc.dart'
    as phone_number_bloc;
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

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
                PrimaryButton(
                  text: "Submit",
                  onTap: () {},
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
    );
  }
}
