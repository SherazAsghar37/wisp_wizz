import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ReceivedMessageCard extends StatelessWidget {
  final List<String> messages;
  final String time;
  const ReceivedMessageCard({
    super.key,
    required this.messages,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: index == messages.length - 1
                                ? Radius.circular(borderRadius - 5)
                                : Radius.circular(borderRadius),
                            bottomRight: Radius.circular(borderRadius),
                            topLeft: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          )),
                      child: Text(messages[index],
                          softWrap: true,
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: theme.colorScheme.background)),
                    ),
                    SizedBox(
                      height: Dimensions.height3,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: Dimensions.width2,
                  ),
                  Text(time,
                      maxLines: 1,
                      softWrap: false,
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
