import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/utils/dimensions.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  const InputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      showCursor: true,
      readOnly: true,
      autofocus: true,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      style: theme.textTheme.bodyMedium,
      cursorColor: theme.primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        hintText: "345678900",
        filled: true,
        fillColor: theme.primaryColorLight,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
      ),
    );
  }
}
