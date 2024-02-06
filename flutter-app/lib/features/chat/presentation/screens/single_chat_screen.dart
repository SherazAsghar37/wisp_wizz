import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/shared/widgets/input_field.dart';
import 'package:wisp_wizz/features/chat/presentation/utils/exports.dart';

class SingleChatScreen extends StatefulWidget {
  static const String routeName = singleChatScreen;
  final UserModel user;
  const SingleChatScreen({super.key, required this.user});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  TextEditingController messageController = TextEditingController();

  bool isRecording = false;
  String recordingTime = '0:0';
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

  final double micAlignment = 0.8;
  double micDynamicAlignment = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background.withOpacity(0.96),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            SingleChatCard(
              user: widget.user,
              color: theme.colorScheme.background,
              onPressed: () {},
              onSelected: (value) {},
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        // padding: EdgeInsets.symmetric(horizontal: Dimensions.width5),
        height: Dimensions.height50,
        decoration: BoxDecoration(
            color: theme.primaryColorLight,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Stack(
          children: [
            Row(children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    attachIcon,
                  )),
              !isRecording
                  ? SizedBox(
                      height: Dimensions.height35,
                      width: Dimensions.width180,
                      child: InputField(
                        controller: messageController,
                        hintText: "Message",
                        iconSize: Dimensions.height18,
                        textStyle: theme.textTheme.bodyMedium!
                            .copyWith(fontSize: Dimensions.height15),
                        contentPadding:
                            EdgeInsets.only(left: Dimensions.width10),
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
                  onPressed: () {
                    print("pressed");
                    BotToast.showText(
                        text: "Hold to send",
                        contentColor: theme.primaryColorLight,
                        textStyle: theme.textTheme.bodyMedium!);
                  },
                  icon: const Icon(
                    cameraIcon,
                  )),
            ]),
            GestureDetector(
              onLongPressMoveUpdate: (details) {
                // DebugHelper.printError(
                //     details.localOffsetFromOrigin.toString());
                if (details.localOffsetFromOrigin.dx <= -1 &&
                    details.localOffsetFromOrigin.dx >= -100) {
                  setState(() {
                    micDynamicAlignment =
                        0.8 + details.localOffsetFromOrigin.dx / 250;
                  });
                  print(micDynamicAlignment);
                }
                // if (details.globalPosition.dx < 180) {
                //   BotToast.showText(
                //       text: "Canceled",
                //       contentColor: theme.primaryColorLight,
                //       textStyle: theme.textTheme.bodyMedium!);
                //   setState(() {
                //     isRecording = false;
                //   });
                // }
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
                    print("pressed");
                    BotToast.showText(
                        text: "Hold to send",
                        contentColor: theme.primaryColorLight,
                        textStyle: theme.textTheme.bodyMedium!);
                  },
                  icon: const Icon(micIcon),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// GestureDetector(
                  // onLongPressStart: (details) {
                  //   print("ASda");
                  // },
                  // onLongPressMoveUpdate: (details) {
                  //   if (details.globalPosition.dx < 180) {
                  //     BotToast.showText(
                  //         text: "Canceled",
                  //         contentColor: theme.primaryColorLight,
                  //         textStyle: theme.textTheme.bodyMedium!);
                  //     setState(() {
                  //       isRecording = false;
                  //     });
                  //   }
                  // },
                  // onLongPress: () {
                  //   setState(() {
                  //     isRecording = true;
                  //   });
                  //   recordTime();
                  // },
                  // onLongPressCancel: () {
                  //   DebugHelper.printWarning("cenceled");
                  // },
                  // onLongPressEnd: (details) {
                  //   // if (details.globalPosition.dx < 180) {
                  //   //   BotToast.showText(
                  //   //       text: "Canceled",
                  //   //       contentColor: theme.primaryColorLight,
                  //   //       textStyle: theme.textTheme.bodyMedium!);
                  //   // }
                  //   setState(() {
                  //     isRecording = false;
                  //   });
                  // },
//                   child: IconButton(
//                     onPressed: () {
//                       print("pressed");
//                       BotToast.showText(
//                           text: "Hold to send",
//                           contentColor: theme.primaryColorLight,
//                           textStyle: theme.textTheme.bodyMedium!);
//                     },
//                     icon: const Icon(micIcon),
//                   )),