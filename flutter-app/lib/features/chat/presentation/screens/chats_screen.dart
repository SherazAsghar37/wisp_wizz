import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final UserModel user = UserModel.empty();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5, vertical: Dimensions.height5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent",
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: colorScheme.primary),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
            ChatCard(
              user: user,
              lastMessage: "asfasfasfas dasfasf asfasf afsf",
              lastMessageTime: DateTime.now(),
              messageStatus: "read",
              notifications: "1000000000000",
            )
          ],
        ),
      ),
    );
  }
}
