import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/colors.dart';
import 'package:wisp_wizz/core/dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLogPress;
  const PrimaryButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.onLogPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTap,
      onLongPress: onLogPress,
      child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10, horizontal: Dimensions.width10),
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.height10)),
          child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      color: theme.primaryColor,
                    )
                  : Text(
                      text!,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: whiteColor),
                    ))),
    );
  }
}
