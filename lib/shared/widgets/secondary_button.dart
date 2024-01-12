import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/utils/dimensions.dart';

class SecondaryButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLogPress;
  const SecondaryButton({
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
        onLongPress: onLogPress,
        onPressed: onTap,
        child: Container(
            height: Dimensions.height50,
            width: Dimensions.width100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.height10),
              color: theme.primaryColorLight,
            ),
            child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: theme.primaryColor,
                      )
                    : Text(
                        text!,
                        style: theme.textTheme.bodyLarge,
                      ))));
  }
}
