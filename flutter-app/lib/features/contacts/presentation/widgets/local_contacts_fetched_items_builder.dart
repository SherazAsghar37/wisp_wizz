import 'package:wisp_wizz/features/contacts/presentation/utils/contacts_exports.dart';

class LocalContactsFetchedItemsBuilder extends StatelessWidget {
  final LocalContactsFetched state;
  final UserModel user;
  const LocalContactsFetchedItemsBuilder({
    super.key,
    required this.state,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
      itemCount: state.contacts.length,
      itemBuilder: (context, index) {
        return BlocConsumer<ChatBloc, ChatState>(
          builder: (context, chatState) {
            return chatState is ChatFetching
                ? ContactCard(
                    contact: state.contacts[index],
                    isLoading: index == chatState.index,
                  )
                : MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AuthloggedIn senderState =
                          context.read<AuthBloc>().state as AuthloggedIn;
                      context.read<ChatBloc>().add(ChatFetchEvent(
                          recipientId: state.contacts[index].id,
                          senderId: senderState.user.id,
                          index: index));
                    },
                    child: ContactCard(
                      contact: state.contacts[index],
                      isLoading: false,
                    ),
                  );
          },
          listener: (context, chatState) {
            if (chatState is ChatFetched && index == 0) {
              final currentChatBloc = context.read<CurrentChatBloc>();
              final userChatsBloc = context.read<UserChatsBloc>();
              final userChatsBlocState = userChatsBloc.state;

              currentChatBloc.add(CurrentChatOpenEvent(
                  chatId: state.contacts[index].id,
                  userId: user.id,
                  index: null));
              Navigator.pushNamed(context, SingleChatScreen.routeName,
                      arguments: [chatState.chat, index])
                  .then((value) => currentChatBloc
                      .add(CurrentChatCloseEvent(userId: user.id)));

              if (userChatsBlocState is UsersChatsFetched) {
                userChatsBloc.add(IntiChatUserChatsEvent(
                    chats: userChatsBlocState.chats,
                    totalUnreadMessages: userChatsBlocState.totalUnreadMessages,
                    index: null,
                    chatId: state.contacts[index].id));
              }
            } else if (chatState is ChatFetchFailed) {
              BotToast.showText(
                  text: chatState.message,
                  contentColor: theme.primaryColorLight,
                  textStyle: theme.textTheme.bodyMedium!);
            }
          },
        );
      },
    );
  }
}
