import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class Utils {
  static ImageProvider<Object> getUserImage(UserModel user) {
    if (user.image != null) {
      return Image.file(File(user.image!)).image;
    } else {
      return Image.asset("images/profile.png").image;
    }
  }

  static Future<void> showAlertDialogue(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, String content,
      {required String sucessBtnName,
      required String failureBtnName,
      required Function success}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.background,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.height10)),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                success();
              },
              child: Text(
                sucessBtnName,
                style: theme.textTheme.bodyMedium,
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                failureBtnName,
                style: theme.textTheme.bodyMedium,
              )),
        ],
      ),
    );
  }
}
