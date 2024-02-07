import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/message_input_container.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final UserModel user;
  const SingleChatScreen({super.key, required this.user});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  int currIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background.withOpacity(0.95),
        extendBodyBehindAppBar: true,
        body: GestureDetector(
          onTap: () {
            setState(() {
              currIndex = 0;
            });
            print("gesture");
          },
          child: SafeArea(
            child: Column(
              children: [
                SingleChatCard(
                  user: widget.user,
                  color: theme.colorScheme.background,
                  onPressed: () {},
                  onSelected: (value) {},
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const MessageInputContainer());
  }
}
