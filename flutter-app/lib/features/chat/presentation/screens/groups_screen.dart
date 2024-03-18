import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ChatModel chat = ChatModel.empty();
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Groups",
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.primaryColorDark),
                ),
                SizedBox(
                  width: Dimensions.width5,
                ),
                const NotificationIcon(
                  notifications: "100",
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.height2),
                    child: ChatCard(
                      chat: chat,
                      onPressed: () {},
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          addIcon,
          size: Dimensions.height25,
        ),
      ),
    );
  }
}
