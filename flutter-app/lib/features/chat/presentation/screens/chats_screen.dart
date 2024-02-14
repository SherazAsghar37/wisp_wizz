import 'package:wisp_wizz/features/chat/presentation/screens/single_chat_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ChatsScreen extends StatelessWidget {
  final UserModel user;
  const ChatsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final UserModel user = UserModel.empty();
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
                  "Chats",
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
                      user: user,
                      lastMessage: "Hello there $index",
                      lastMessageTime: DateTime.now(),
                      messageStatus: index % 2 == 0 ? "read" : "sent",
                      notifications: "1000000000000",
                      onPressed: () {
                        Navigator.pushNamed(context, SingleChatScreen.routeName,
                            arguments: user);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await FlutterContacts.requestPermission()) {
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, ContactsScreen.routeName);
          }
        },
        child: Icon(
          chatIcon,
          size: Dimensions.height30,
        ),
      ),
    );
  }
}
