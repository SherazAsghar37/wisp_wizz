import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/utils/dimensions.dart';

class PrimaryIcon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  const PrimaryIcon({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: Dimensions.height40,
      width: Dimensions.height40,
      decoration: BoxDecoration(
          color: theme.primaryColorLight,
          borderRadius: BorderRadius.circular(Dimensions.height10)),
      child: Center(
          child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          iconData,
        ),
      )),
    );
  }
}
