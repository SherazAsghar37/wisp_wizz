import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/colors.dart';
import 'package:wisp_wizz/core/dimensions.dart';

class DigitInputField extends StatelessWidget {
  // final FocusNode focusNode;
  // final TextEditingController textEditingController;
  final String text;
  final int index;
  final int focusIndex;
  const DigitInputField({
    super.key,
    // required this.textEditingController,
    required this.index,
    required this.focusIndex,
    required this.text,
    // required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onDoubleTap: () {
        // focusNode.unfocus();
      },
      child: Container(
        width: Dimensions.width50,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  index == focusIndex ? theme.primaryColor : transparentColor),
          borderRadius: BorderRadius.circular(Dimensions.height10),
          color: theme.primaryColorLight,
        ),
        child: Center(
            child: Text(
          text,
          style: theme.textTheme.bodyLarge,
        )
            //  TextField(
            //   onTap: () {
            //     // focusNode.unfocus();
            //   },
            //   // focusNode: focusNode,
            //   controller: textEditingController,
            //   showCursor: true,
            //   readOnly: true,
            //   autofocus: false,
            //   textAlign: TextAlign.center,
            //   textAlignVertical: TextAlignVertical.center,
            //   style: theme.textTheme.bodyLarge,
            //   cursorColor: theme.primaryColor,
            //   decoration: const InputDecoration(
            //     contentPadding: EdgeInsets.all(20),
            //     hintText: "0",
            //     border: InputBorder.none,
            //     focusedBorder: InputBorder.none,
            //   ),
            // ),
            ),
      ),
    );
  }
}
