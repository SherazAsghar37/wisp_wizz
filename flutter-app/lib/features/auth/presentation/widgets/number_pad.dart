import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/icons_constants.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/shared/widgets/secondary_button.dart';

class NumberPad extends StatelessWidget {
  final TextEditingController controller;
  final Function(int num) onPressed;
  const NumberPad({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, upperIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(3, (lowerIndex) {
                int currentIndex = (upperIndex) * 3 + lowerIndex + 1;
                if (currentIndex == 11) {
                  return SecondaryButton(
                    text: "0",
                    onTap: () {
                      onPressed(0);
                    },
                  );
                } else if (currentIndex == 10) {
                  return SizedBox(
                    height: Dimensions.height50,
                    width: Dimensions.width100,
                  );
                } else if (currentIndex == 12) {
                  return SecondaryButton(
                    icon: backspaceIcon,
                    onTap: () {
                      onPressed(-1);
                    },
                    onLogPress: () {
                      onPressed(-2);
                    },
                  );
                } else {
                  return SecondaryButton(
                    text: currentIndex.toString(),
                    onTap: () {
                      onPressed(currentIndex);
                    },
                  );
                }
              })
            ],
          ),
        );
      },
    );
  }
}
