import 'package:wisp_wizz/features/calls/presentation/utils/calls_utils.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class CallCard extends StatelessWidget {
  final UserModel user;
  final String callType;
  final DateTime lastCallTime;
  final String callStatus;
  CallCard({
    super.key,
    required this.user,
    required this.callType,
    required this.lastCallTime,
    required this.callStatus,
  });

  final double radius = Dimensions.height13 + Dimensions.width13;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return SizedBox(
      // color: Colors.blue,
      height: Dimensions.height55,
      width: Dimensions.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: Dimensions.height50,
                width: Dimensions.width60,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: radius,
                        backgroundColor: colorScheme.primary,
                        child: CircleAvatar(
                          radius: radius - 2,
                          backgroundImage: Utils.getUserImage(user),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CallsUtils.getCallStatusIcon(
                          context, "successfulReceived"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.primaryColorDark,
                        fontSize: Dimensions.height18),
                  ),
                  SizedBox(
                      width: Dimensions.screenWidth * 0.45,
                      child: Text(
                        lastCallTime.toString().substring(2, 10),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: Dimensions.height13,
                        ),
                      )),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [CallsUtils.getCallIcon(context, "missedSent", "voice")],
          )
        ],
      ),
    );
  }
}
