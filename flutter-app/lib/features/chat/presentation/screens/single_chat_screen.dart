import 'dart:developer';

import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final ChatModel chat;
  const SingleChatScreen({super.key, required this.chat});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

MessageModel message = MessageModel.empty();

class _SingleChatScreenState extends State<SingleChatScreen> {
  final List<MessageModel> messages = [];
  @override
  void initState() {
    context.read<MessageBloc>().messagesStream.listen((event) {
      if (event.isNotEmpty && event[0].chatId == widget.chat.chatId) {
        messages.addAll(event);
      }
    });
    context
        .read<MessageBloc>()
        .add(FetchMessagesEvent(chatId: widget.chat.chatId));

    super.initState();
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                        }))
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
