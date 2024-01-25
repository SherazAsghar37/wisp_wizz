import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/theme/colors.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Widget? widget;
  final VoidCallback onTap;
  final VoidCallback? onLogPress;
  const PrimaryButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.onLogPress,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTap,
      onLongPress: onLogPress,
      child: Container(
          height: Dimensions.height50,
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
                  : widget ??
                      Text(
                        text!,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: whiteColor),
                      ))),
    );
  }
}
