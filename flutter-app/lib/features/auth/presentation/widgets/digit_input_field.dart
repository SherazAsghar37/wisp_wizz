import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/theme/colors.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class DigitInputField extends StatelessWidget {
  final String text;
  final int index;
  final int focusIndex;
  const DigitInputField({
    super.key,
    required this.index,
    required this.focusIndex,
    required this.text,
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
        )),
      ),
    );
  }
}
