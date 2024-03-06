import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final ChatModel chat;
  const SingleChatScreen({super.key, required this.chat});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

MessageModel message = MessageModel.empty();
const String senderId = "abc";
const String recipientId = "xyz";

class _SingleChatScreenState extends State<SingleChatScreen> {
  final List<MessageModel> messages = [
    message.copyWith(
        message: "this is a text message from friend.",
        senderId: senderId,
        recipientId: recipientId),
    message.copyWith(
        message: "gida gadi gida gida o",
        senderId: senderId,
        recipientId: recipientId),
    message.copyWith(
        message: "Ai bi merri along time go,",
        senderId: senderId,
        recipientId: recipientId),
    message.copyWith(
        message: " wud u du cum for ",
        senderId: recipientId,
        recipientId: senderId),
    message.copyWith(
        message: "wud u do go", senderId: recipientId, recipientId: senderId),
    message.copyWith(
        message: "wud yu du cum for putlando",
        senderId: recipientId,
        recipientId: senderId),
    message.copyWith(
        message: "Zzzzz", senderId: senderId, recipientId: recipientId),
    message.copyWith(
        message:
            "processMotionEvent MotionEvent { action=ACTION_DOWN, actionButton=0, id[0]=0, x[0]=208.0, y[0]=1097.0, toolType[0]=TOOL_TYPE_FINGER, buttonState=0, classification=NONE, metaState=0, flags=0x0, edgeFlags=0x0, pointerCount=1, historySize=0, eventTime=82226094, downTime=82226094, deviceId=3, source=0x1002, displayId=0 }",
        senderId: senderId,
        recipientId: recipientId),
    message.copyWith(
        message:
            "processMotionEvent MotionEvent { action=ACTION_DOWN, actionButton=0, id[0]=0, x[0]=208.0, y[0]=1097.0, toolType[0]=TOOL_TYPE_FINGER, buttonState=0, classification=NONE, metaState=0, flags=0x0, edgeFlags=0x0, pointerCount=1, historySize=0, eventTime=82226094, downTime=82226094, deviceId=3, source=0x1002, displayId=0 }",
        senderId: recipientId,
        recipientId: senderId)
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background.withOpacity(0.95),
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
                  onSelected: (value) {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.width10, 0,
                          Dimensions.width10, Dimensions.height50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          ...List.generate(
                              messages.length,
                              (index) => ChatUtils.messageCardManager(
                                  index: index,
                                  messages: messages,
                                  chat: widget.chat))
                        ],
                      ),
                    ),
                  ),
                )
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
