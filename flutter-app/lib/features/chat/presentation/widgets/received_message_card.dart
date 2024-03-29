import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ReceivedMessageCard extends StatelessWidget {
  final MessageModel message;
  final bool isLast;
  const ReceivedMessageCard({
    super.key,
    required this.message,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height3),
          child: Container(
            constraints: BoxConstraints(maxWidth: Dimensions.screenWidth * 0.7),
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10,
              horizontal: Dimensions.width10,
            ),
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: isLast
                      ? Radius.circular(borderRadius - 5)
                      : Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.message,
                    softWrap: true,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: theme.colorScheme.background)),
                SizedBox(
                  height: Dimensions.height2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message.createdAt.timeFormat(),
                        maxLines: 1,
                        softWrap: false,
                        style: theme.textTheme.bodySmall!.copyWith(
                            fontSize: Dimensions.height10,
                            color:
                                theme.colorScheme.background.withOpacity(0.9))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
