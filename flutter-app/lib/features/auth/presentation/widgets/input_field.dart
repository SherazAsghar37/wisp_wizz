import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Radius? leftBorder;
  final bool? readonly;
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.leftBorder,
    this.readonly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      showCursor: true,
      readOnly: readonly ?? false,
      autofocus: true,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      style: theme.textTheme.bodyMedium,
      cursorColor: theme.primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        hintText: hintText,
        filled: true,
        fillColor: theme.primaryColorLight,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10),
                topLeft: leftBorder ?? Radius.circular(Dimensions.height10),
                bottomLeft: leftBorder ?? Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10),
                topLeft: leftBorder ?? Radius.circular(Dimensions.height10),
                bottomLeft: leftBorder ?? Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
      ),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
