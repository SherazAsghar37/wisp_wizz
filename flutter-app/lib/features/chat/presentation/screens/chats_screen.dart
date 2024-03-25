// ignore_for_file: use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/screens/single_chat_screen.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wisp_wizz/features/contacts/presentation/bloc/contact_bloc.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = (context.read<AuthBloc>().state as AuthloggedIn).user;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width5,
        ),
        child: BlocBuilder<UserChatsBloc, UserChatsState>(
            builder: (context, state) {
          return Column(
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
                  state is UsersChatsFetched && state.totalUnreadMessages > 0
                      ? NotificationIcon(
                          notifications: state.totalUnreadMessages.toString(),
                        )
                      : state is UsersChatsFetching &&
                              state.totalUnreadMessages > 0
                          ? NotificationIcon(
                              notifications:
                                  state.totalUnreadMessages.toString(),
                            )
                          : const SizedBox()
                ],
              ),
              state is UsersChatsFetching
                  ? Expanded(
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height5),
                        itemCount: state.chats.length + 1,
                        itemBuilder: (context, index) {
                          return index == state.chats.length
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: Dimensions.height40,
                                    width: 0,
                                    child: FittedBox(
                                      child: CircularProgressIndicator(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height2),
                                  child: ChatCard(
                                    chat: state.chats[index],
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, SingleChatScreen.routeName,
                                          arguments: [
                                            state.chats[index],
                                            index
                                          ]);
                                      final chatBloc =
                                          context.read<UserChatsBloc>();

                                      // chatBloc.add(FetchUpdatedUserChatsEvent(
                                      //     chats: state.chats,
                                      //     userId: user.id,
                                      //     totalUnreadMessages:
                                      //         state.totalUnreadMessages));
                                    },
                                  ),
                                );
                        },
                      ),
                    )
                  : state is UsersChatsFetched
                      ? BlocListener<MessageBloc, MessageState>(
                          listener: (context, messageState) {
                            if (messageState is MessageReceived) {
                              DebugHelper.printError("here");
                              // context.read<UserChatsBloc>().add(
                              //     AddMessageUserChatsEvent(
                              //         chats: state.chats,
                              //         userId: user.id,
                              //         totalUnreadMessages:
                              //             state.totalUnreadMessages,
                              //         message: messageState.message));
                            }
                          },
                          child: state.chats.isEmpty
                              ? const Center(
                                  child: Text("No chats found"),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.height5),
                                    itemCount: state.chats.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimensions.height2),
                                        child: ChatCard(
                                          chat: state.chats[index],
                                          onPressed: () {
                                            final chatBloc =
                                                context.read<UserChatsBloc>();
                                            context.read<MessageBloc>().add(
                                                InitMessagesEvent(
                                                    messages: state.chats[index]
                                                        .messages));
                                            Navigator.pushNamed(context,
                                                SingleChatScreen.routeName,
                                                arguments: [
                                                  state.chats[index],
                                                  index,
                                                ]);
                                            // chatBloc.add(
                                            //     FetchUpdatedUserChatsEvent(
                                            //         chats: state.chats,
                                            //         userId: user.id,
                                            //         totalUnreadMessages: state
                                            //             .totalUnreadMessages));
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        )
                      : state is UsersChatsFetchFailed
                          ? Center(child: Text(state.message))
                          : const Center(child: Text("unknown error occured"))
            ],
          );
        }),
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
