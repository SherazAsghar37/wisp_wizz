import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatCard extends StatelessWidget {
  final UserModel user;
  final String? lastMessage;
  final String? notifications;
  final DateTime? lastMessageTime;
  final String? messageStatus;
  final VoidCallback onPressed;
  ChatCard({
    super.key,
    required this.user,
    this.lastMessage,
    this.notifications,
    this.lastMessageTime,
    this.messageStatus,
    required this.onPressed,
  });

  final double radius = Dimensions.height13 + Dimensions.width13;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  backgroundColor: colorScheme.primary,
                  child: CircleAvatar(
                    radius: radius - 2,
                    backgroundImage: Utils.getUserImage(user),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        messageStatus != null
                            ? Row(
                                children: [
                                  ChatUtils.getMessageStatusIcon(
                                      context, messageStatus!),
                                  SizedBox(
                                    width: Dimensions.width2,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: Dimensions.screenWidth * 0.45,
                          child: Text(lastMessage ?? "",
                              maxLines: 1,
                              softWrap: false,
                              style: theme.textTheme.bodySmall!
                                  .copyWith(fontSize: Dimensions.height14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                notifications != null
                    ? NotificationIcon(
                        notifications: notifications!,
                      )
                    : const SizedBox(),
                Text(
                  lastMessageTime?.toString().substring(2, 10) ?? "",
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
