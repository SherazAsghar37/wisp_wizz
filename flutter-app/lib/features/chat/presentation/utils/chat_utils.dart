import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatUtils {
  static Widget getMessageStatusIcon(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "sent":
        return Icon(
          starHalfIcon,
          color: colorScheme.primary,
          size: Dimensions.height17,
        );
      case "sending":
        return Icon(
          clockIcon,
          size: Dimensions.height17,
          color: colorScheme.primary,
        );
      case "received":
        return Icon(
          size: Dimensions.height17,
          starIcon,
          color: colorScheme.primary,
        );
      case "read":
        return Icon(
          size: Dimensions.height17,
          starIcon,
          color: colorScheme.secondary,
        );
      default:
        return const SizedBox();
    }
  }

  static Widget messageCardManager(
      {required int index,
      required List<MessageModel> messages,
      required ChatModel chat}) {
    DebugHelper.printWarning((index < messages.length - 1 &&
            index > 0 &&
            messages[index - 1].senderId != messages[index].senderId)
        .toString());
    final bool formula = (index > 0 &&
                index < messages.length - 1 &&
                messages[index - 1].senderId == messages[index].senderId &&
                messages[index + 1].senderId != messages[index].senderId) ||
            index == messages.length - 1
        ? true
        : false;
    return messages[index].recipientId == chat.recipient.id
        ? ReceivedMessageCard(message: messages[index], isLast: formula)
        : SentMessageCard(message: messages[index], isLast: formula);
  }
}
