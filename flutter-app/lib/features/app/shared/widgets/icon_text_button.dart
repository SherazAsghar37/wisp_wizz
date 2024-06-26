import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/dimensions.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  const IconTextButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height10, horizontal: Dimensions.width13),
        height: Dimensions.height50,
        decoration: BoxDecoration(
            color: theme.primaryColorLight,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.shadowColor,
                ),
                SizedBox(
                  width: Dimensions.width13,
                ),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            isLoading
                ? SizedBox(
                    height: Dimensions.height20,
                    child: FittedBox(
                        child: CircularProgressIndicator(
                      color: theme.primaryColor,
                      strokeWidth: 2,
                    )))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
