import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SentMessageCard extends StatelessWidget {
  final MessageModel message;
  final bool isLast;
  const SentMessageCard(
      {super.key, required this.message, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints:
                    BoxConstraints(maxWidth: Dimensions.screenWidth * 0.7),
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10,
                ),
                decoration: BoxDecoration(
                    color: theme.colorScheme.background.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      bottomRight: isLast
                          ? Radius.circular(borderRadius - 5)
                          : Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    )),
                child: Text(message.message,
                    softWrap: true,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: theme.shadowColor)),
              ),
              isLast
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ChatUtils.getMessageStatusIcon(
                                context, message.messageStatus),
                            SizedBox(
                              width: Dimensions.width2,
                            ),
                            Text(message.createdAt.timeFormat(),
                                maxLines: 1,
                                softWrap: false,
                                style: theme.textTheme.bodySmall),
                            SizedBox(
                              width: Dimensions.width5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
