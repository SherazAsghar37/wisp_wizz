import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final ChatModel chat;
  final int index;
  const SingleChatScreen({super.key, required this.chat, required this.index});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  List<MessageModel> messages = [];
  late StreamSubscription<List<MessageModel>> streamSubscription;
  @override
  void initState() {
    messages = widget.chat.messages;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background.withOpacity(0.9),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: Dimensions.height20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChatCard(
                  user: widget.chat.recipient,
                  color: theme.colorScheme.background,
                  onPressed: () {},
                  onSelected: (value) {
                    SqfliteManager.trunciateMessages();
                  },
                ),
                Expanded(
                    child: BlocListener<MessageBloc, MessageState>(
                        listener: (context, state) {
                          if (state is MessageSent) {
                            final chatBloc = context.read<UserChatsBloc>();
                            final chatState = chatBloc.state;
                            if (chatState is UsersChatsFetched) {
                              chatBloc.add(AddMessageUserChatsEvent(
                                  chats: chatState.chats,
                                  userId: widget.chat.senderId,
                                  totalUnreadMessages:
                                      chatState.totalUnreadMessages,
                                  message: state.message,
                                  index: widget.index,
                                  isChatClosed: false));
                            }
                          }
                        },
                        child: StreamBuilder(
                          stream: context.read<MessageBloc>().messagesStream,
                          builder: (context, snapshot) {
                            return SingleChildScrollView(
                              reverse: true,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(Dimensions.width10,
                                    0, Dimensions.width10, Dimensions.height50),
                                child: messages.isNotEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          ...List.generate(
                                              messages.length,
                                              (index) =>
                                                  ChatUtils.messageCardManager(
                                                      index: index,
                                                      messages: messages,
                                                      chat: widget.chat))
                                        ],
                                      )
                                    : const Text("No data"),
                              ),
                            );
                          },
                        )))
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MessageInputContainer(
          chat: widget.chat,
        ));
  }
}
//  return SizedBox(
//                       height: Dimensions.height40,
//                       width: Dimensions.width40,
//                       child: FittedBox(
//                         child: CircularProgressIndicator(
//                           color: theme.primaryColor,
//                         ),
//                       ),
//                     );