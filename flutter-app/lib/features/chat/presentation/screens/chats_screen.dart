// ignore_for_file: use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/current-chat-bloc/current_chat_bloc.dart';
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
          DebugHelper.printWarning(state.toString());
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
                                    userID: user.id,
                                    onPressed: () {
                                      final currentChatBloc =
                                          context.read<CurrentChatBloc>();
                                      final userChatsBloc =
                                          context.read<UserChatsBloc>();

                                      Navigator.pushNamed(
                                          context, SingleChatScreen.routeName,
                                          arguments: [
                                            state.chats[index],
                                            index,
                                          ]).then((value) => currentChatBloc
                                          .add(CurrentChatCloseEvent(
                                              userId: user.id)));
                                      currentChatBloc.add(CurrentChatOpenEvent(
                                          chatId: state.chats[index].chatId,
                                          userId: user.id,
                                          index: index));
                                      userChatsBloc.add(IntiChatUserChatsEvent(
                                          chats: state.chats,
                                          totalUnreadMessages:
                                              state.totalUnreadMessages,
                                          index: index,
                                          chatId: state.chats[index].chatId));
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
                              final chatBloc = context.read<UserChatsBloc>();
                              final chatState = chatBloc.state;
                              DebugHelper.printWarning("here1");
                              if (chatState is UsersChatsFetched) {
                                chatBloc.add(AddMessageUserChatsEvent(
                                    chats: chatState.chats,
                                    userId: user.id,
                                    recipientId: messageState.message.senderId,
                                    totalUnreadMessages:
                                        chatState.totalUnreadMessages,
                                    message: messageState.message,
                                    isChatClosed: messageState.isChatClosed,
                                    index: messageState.index,
                                    chat: null));
                              }
                            }
                          },
                          child: state.chats.isEmpty
                              ? Expanded(
                                  child: RefreshIndicator(
                                      onRefresh: () async {
                                        final chatBloc =
                                            context.read<UserChatsBloc>();

                                        chatBloc.add(FetchUserChatsEvent(
                                            chats: const [], userId: user.id));
                                      },
                                      child: ListView.builder(
                                        itemCount: 1,
                                        itemBuilder: (context, index) =>
                                            const Center(
                                          child: Text("No chats found"),
                                        ),
                                      )),
                                )
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      DebugHelper.printWarning("heee");
                                      final chatBloc =
                                          context.read<UserChatsBloc>();

                                      chatBloc.add(FetchUserChatsEvent(
                                          chats: const [], userId: user.id));
                                    },
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height5),
                                      itemCount: state.chats.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimensions.height2),
                                          child: ChatCard(
                                            userID: user.id,
                                            chat: state.chats[index],
                                            onPressed: () {
                                              final currentChatBloc = context
                                                  .read<CurrentChatBloc>();
                                              final userChatsBloc =
                                                  context.read<UserChatsBloc>();
                                              currentChatBloc.add(
                                                  CurrentChatOpenEvent(
                                                      chatId: state
                                                          .chats[index].chatId,
                                                      userId: user.id,
                                                      index: index));
                                              Navigator.pushNamed(context,
                                                  SingleChatScreen.routeName,
                                                  arguments: [
                                                    state.chats[index],
                                                    index,
                                                  ]).then((value) =>
                                                  currentChatBloc.add(
                                                      CurrentChatCloseEvent(
                                                          userId: user.id)));

                                              userChatsBloc.add(
                                                  IntiChatUserChatsEvent(
                                                      chats: state.chats,
                                                      totalUnreadMessages: state
                                                          .totalUnreadMessages,
                                                      index: index,
                                                      chatId: state.chats[index]
                                                          .chatId));
                                            },
                                          ),
                                        );
                                      },
                                    ),
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

            Navigator.pushNamed(context, ContactsScreen.routeName,
                arguments: user);
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

void _onChatOpened() {}
