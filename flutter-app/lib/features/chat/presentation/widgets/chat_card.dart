import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final String userID;
  final VoidCallback onPressed;
  ChatCard({
    super.key,
    required this.chat,
    required this.onPressed,
    required this.userID,
  });

  final double radius = Dimensions.height12 + Dimensions.width12;
  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.messages.last;
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
                // CachedNet
                // CircleAvatar(
                //   radius: radius,
                //   backgroundImage: Utils.getUserImageFromUint8List(
                //       null, chat.recipient.image),
                // ),
                CachedNetworkImage(
                  imageUrl: baseUrl + chat.recipient.image,
                  key: ValueKey(Random().nextInt(100)),
                  placeholder: (context, url) => CircleAvatar(
                      radius: radius,
                      backgroundImage: Image.asset("images/profile.png").image),
                  errorWidget: (context, url, error) => CircleAvatar(
                      radius: radius,
                      backgroundImage: Image.asset("images/profile.png").image),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                        radius: radius, backgroundImage: imageProvider);
                  },
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        lastMessage.senderId == userID
                            ? Row(
                                children: [
                                  ChatUtils.getMessageStatusIcon(
                                      context, lastMessage.messageStatus),
                                  SizedBox(
                                    width: Dimensions.width2,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: Dimensions.screenWidth * 0.45,
                          child: Text(lastMessage.message,
                              maxLines: 1,
                              softWrap: false,
                              style: theme.textTheme.bodySmall!
                                  .copyWith(fontSize: Dimensions.height14)),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                chat.unreadMessages > 0
                    ? NotificationIcon(
                        notifications: chat.unreadMessages.toString(),
                      )
                    : const SizedBox(),
                Text(
                  lastMessage.createdAt.timeFormat(),
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
