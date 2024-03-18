import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onPressed;
  ChatCard({
    super.key,
    required this.chat,
    required this.onPressed,
  });

  final double radius = Dimensions.height12 + Dimensions.width12;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: SizedBox(
        // color: Colors.blue,
        height: Dimensions.height55,
        width: Dimensions.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: radius,
                  backgroundImage:
                      Utils.getUserImageFromUint8List(chat.recipient.image),
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.recipient.name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.primaryColorDark,
                          fontSize: Dimensions.height18),
                    ),
                    chat.lastMessage != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  ChatUtils.getMessageStatusIcon(
                                      context, chat.lastMessage!.messageStatus),
                                  SizedBox(
                                    width: Dimensions.width2,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: Dimensions.screenWidth * 0.45,
                                child: Text(chat.lastMessage!.message,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        fontSize: Dimensions.height14)),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                chat.totalUnReadMessages != null &&
                        chat.totalUnReadMessages! > 0
                    ? NotificationIcon(
                        notifications: chat.totalUnReadMessages.toString(),
                      )
                    : const SizedBox(),
                Text(
                  chat.lastMessage?.createdAt.timeFormat() ?? "",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: Dimensions.height13,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
