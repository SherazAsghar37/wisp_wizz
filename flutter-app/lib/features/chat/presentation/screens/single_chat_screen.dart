import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/message_input_container.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/received_message_card.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/sent_message_card.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final UserModel user;
  const SingleChatScreen({super.key, required this.user});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background.withOpacity(0.95),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChatCard(
                user: widget.user,
                color: theme.colorScheme.background,
                onPressed: () {},
                onSelected: (value) {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Dimensions.width10, 0,
                        Dimensions.width10, Dimensions.height70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        const ReceivedMessageCard(messages: [
                          "this is a text message from friend.",
                          "gida gadi gida gida o",
                          "Ai bi merri along time go, wud u du cum for wud u do go, wud yu du cum for putlando"
                        ], time: "12:30PM"),
                        const SentMessageCard(
                          messages: [
                            "Ai bi merri along time go, wud u du cum for wud u do go, wud yu du cum for putlando",
                            "gida gadi gida gida o",
                            "this is a text message from me."
                          ],
                          time: "12:30PM",
                          status: "read",
                        ),
                        const ReceivedMessageCard(messages: [
                          "this is a text message from friend.",
                          "gida gadi gida gida o",
                          "Ai bi merri along time go, wud u du cum for wud u do go, wud yu du cum for putlando"
                        ], time: "12:30PM"),
                        const SentMessageCard(
                          messages: [
                            "Ai bi merri along time go, wud u du cum for wud u do go, wud yu du cum for putlando",
                            "gida gadi gida gida o",
                            "this is a text message from me."
                          ],
                          time: "12:30PM",
                          status: "read",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const MessageInputContainer());
  }
}
