import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatUtils {
  static Widget getMessageStatusIcon(BuildContext context, String status,
      {double? inconSize}) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "Sent":
        return Icon(
          starHalfIcon,
          color: colorScheme.primary,
          size: inconSize ?? Dimensions.height17,
        );
      case "Sending":
        return Icon(
          clockIcon,
          size: inconSize ?? Dimensions.height17,
          color: colorScheme.primary,
        );
      case "Delivered":
        return Icon(
          size: inconSize ?? Dimensions.height17,
          starIcon,
          color: colorScheme.primary,
        );
      case "Seen":
        return Icon(
          size: inconSize ?? Dimensions.height17,
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
    final bool senderFormula = (index < messages.length - 1 &&
                messages[index + 1].senderId != messages[index].senderId) ||
            index == messages.length - 1
        ? true
        : false;
    final bool recipientFormula = (index < messages.length - 1 &&
                messages[index + 1].recipientId !=
                    messages[index].recipientId) ||
            index == messages.length - 1
        ? true
        : false;
    return messages[index].senderId == chat.senderId
        ? SentMessageCard(message: messages[index], isLast: senderFormula)
        : ReceivedMessageCard(
            message: messages[index], isLast: recipientFormula);
  }
}
