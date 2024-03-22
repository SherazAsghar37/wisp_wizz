// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisp_wizz/features/app/shared/widgets/switchable_icons.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/message-bloc/message_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/bloc/user-chats/user_chats_bloc.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/chat/presentation/widgets/attachment_button.dart';
// import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart'
//     as auth;

class MessageInputContainer extends StatefulWidget {
  final ChatModel chat;
  const MessageInputContainer({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<MessageInputContainer> createState() => _MessageInputContainerState();
}

class _MessageInputContainerState extends State<MessageInputContainer> {
  TextEditingController messageController = TextEditingController();
  bool isRecording = false;
  bool isTyping = false;
  int currIndex = 0;
  String recordingTime = '0:0';
  final double micAlignment = 0.8;
  double micDynamicAlignment = 0.8;

  void recordTime() {
    var startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 0), (Timer t) {
      var diff = DateTime.now().difference(startTime);
      recordingTime =
          '${diff.inHours == 0 ? '' : '${diff.inHours.toString().padLeft(2, "0")}:'}${(diff.inMinutes % 60).floor().toString().padLeft(2, "0")}:${(diff.inSeconds % 60).floor().toString().padLeft(2, '0')}';
      if (!isRecording) {
        t.cancel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TapRegion(
      onTapOutside: (event) {
        setState(() {
          currIndex = 0;
        });
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              // padding: EdgeInsets.symmetric(horizontal: Dimensions.width5),
              height: Dimensions.height50,
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Stack(
                children: [
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            currIndex = currIndex == 0 ? 1 : 0;
                          });
                        },
                        icon: SwitchableIcon(
                          intitalIcon: attachIcon,
                          finalIcon: attachIcon,
                          angle: 2.35,
                          currIndex: currIndex,
                        )),
                    !isRecording
                        ? SizedBox(
                            height: Dimensions.height35,
                            width: Dimensions.width180,
                            child: InputField(
                              controller: messageController,
                              hintText: "Type your Message...",
                              iconSize: Dimensions.height18,
                              textStyle: theme.textTheme.bodyMedium!
                                  .copyWith(fontSize: Dimensions.height15),
                              contentPadding:
                                  EdgeInsets.only(left: Dimensions.width10),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isTyping = false;
                                  });
                                } else if (!isTyping) {
                                  setState(() {
                                    isTyping = true;
                                  });
                                }
                              },
                            ))
                        : SizedBox(
                            width: Dimensions.width180,
                            child: Row(children: [
                              Transform.flip(
                                  flipX: true,
                                  child: Icon(
                                    doubleArrowIcon,
                                    size: Dimensions.height30,
                                  )),
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                              Text(
                                recordingTime,
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontSize: Dimensions.height15),
                              )
                            ]),
                          ),
                    SizedBox(
                      height: Dimensions.height25,
                      width: Dimensions.width45,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          cameraIcon,
                        )),
                  ]),
                  !isTyping
                      ? GestureDetector(
                          onLongPressMoveUpdate: (details) {
                            if (details.localOffsetFromOrigin.dx <= -1 &&
                                details.localOffsetFromOrigin.dx >= -100) {
                              setState(() {
                                micDynamicAlignment = 0.8 +
                                    details.localOffsetFromOrigin.dx / 250;
                              });
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              isRecording = true;
                            });
                            recordTime();
                          },
                          onLongPressEnd: (details) {
                            setState(() {
                              isRecording = false;
                              micDynamicAlignment = micAlignment;
                            });
                          },
                          child: AnimatedAlign(
                            alignment: FractionalOffset(micDynamicAlignment, 0),
                            duration: const Duration(milliseconds: 100),
                            child: IconButton(
                              onPressed: () {
                                BotToast.showText(
                                    text: "Hold to send",
                                    contentColor: theme.primaryColorLight,
                                    textStyle: theme.textTheme.bodyMedium!);
                              },
                              icon: const Icon(micIcon),
                            ),
                          ),
                        )
                      : Align(
                          alignment: FractionalOffset(micAlignment, 0),
                          child: IconButton(
                              onPressed: () {
                                // final authbloc = context
                                //     .read<auth.AuthBloc>()
                                //     .state as auth.AuthloggedIn;
                                final chat = widget.chat;
                                context
                                    .read<MessageBloc>()
                                    .add(SendMessageEvent(
                                      senderId: chat.senderId,
                                      recipientId: chat.recipient.id,
                                      message: messageController.text,
                                      chatId: chat.chatId,
                                    ));

                                setState(() {
                                  messageController.clear();
                                });
                                final chatBloc = context.read<UserChatsBloc>();
                                final chatState = chatBloc.state;
                                if (chatState is UsersChatsFetched) {
                                  chatBloc.add(FetchUpdatedUserChatsEvent(
                                      chats: chatState.chats,
                                      userId: chatState.chats[0].senderId));
                                }
                              },
                              icon: const Icon(sendIcon)),
                        )
                ],
              ),
            ),
          ),
          currIndex == 1
              ? Align(
                  alignment: const FractionalOffset(1, 0.92),
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height5),
                    width: Dimensions.screenWidth,
                    height: Dimensions.height80,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(borderRadius)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AttachmentButton(
                          icon: documnetIcon,
                          name: "Document",
                          onPresed: () {},
                        ),
                        AttachmentButton(
                          icon: imageIcon,
                          name: "Image",
                          onPresed: () {},
                        ),
                        AttachmentButton(
                          icon: cameraIcon,
                          name: "Camera",
                          onPresed: () {},
                        ),
                        AttachmentButton(
                          icon: headphonesIcon,
                          name: "Audio",
                          onPresed: () {},
                        )
                      ],
                    ),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
