import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SentMessageCard extends StatelessWidget {
  final List<String> messages;
  final String time;
  final String status;
  const SentMessageCard({
    super.key,
    required this.messages,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...List.generate(
                messages.length,
                (index) => Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: Dimensions.screenWidth * 0.7),
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height10,
                        horizontal: Dimensions.width10,
                      ),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.background.withOpacity(0.7),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderRadius),
                            bottomRight: index == messages.length - 1
                                ? Radius.circular(borderRadius - 5)
                                : Radius.circular(borderRadius),
                            topLeft: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          )),
                      child: Text(messages[index],
                          softWrap: true,
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: theme.shadowColor)),
                    ),
                    SizedBox(
                      height: Dimensions.height2,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ChatUtils.getMessageStatusIcon(context, status),
                  SizedBox(
                    width: Dimensions.width2,
                  ),
                  Text(time,
                      maxLines: 1,
                      softWrap: false,
                      style: theme.textTheme.bodySmall),
                  SizedBox(
                    width: Dimensions.width5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
