// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/single_chat_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wisp_wizz/features/contacts/presentation/bloc/contact_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            BlocBuilder<UserChatsBloc, UserChatsState>(
              builder: (context, state) {
                if (state is UsersChatsFetching) {
                  return Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height5),
                      itemCount: state.chats.length + 1,
                      itemBuilder: (context, index) {
                        return index == state.chats.length
                            ? CircularProgressIndicator(
                                color: theme.primaryColor,
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height2),
                                child: ChatCard(
                                  chat: state.chats[index],
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SingleChatScreen.routeName,
                                        arguments: ChatModel.empty());
                                  },
                                ),
                              );
                      },
                    ),
                  );
                } else if (state is UsersChatsFetched) {
                  return Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height5),
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height2),
                          child: ChatCard(
                            chat: state.chats[index],
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, SingleChatScreen.routeName,
                                      arguments: state.chats[index])
                                  .then((value) {
                                print("heeeeeeeeeeeeeeeeeeeeeee");
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is UsersChatsFetchFailed) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("unknown error occured"));
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await FlutterContacts.requestPermission()) {
            final contactsBloc = context.read<ContactBloc>();
            if (contactsBloc.state is! ContactsFetched) {
              context.read<ContactBloc>().add(const ContactFetchEvent());
            }

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
