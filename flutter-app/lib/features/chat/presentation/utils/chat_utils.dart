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
}
