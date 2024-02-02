import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/icons_constants.dart';
import 'package:wisp_wizz/features/app/utils/dimensions.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class Utils {
  static ImageProvider<Object> getUserImage(UserModel user) {
    try {
      if (user.image != null) {
        return Image.file(File(user.image!)).image;
      } else {
        return Image.asset("images/profile.png").image;
      }
    } catch (e) {
      return Image.asset("images/profile.png").image;
    }
  }

  static Future<void> showAlertDialogue(BuildContext context, String content,
      {required String sucessBtnName,
      required String failureBtnName,
      required Function success}) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
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

  static Future<int?> showPopupMenu(
      BuildContext context, List<String> options) async {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    int? val;
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 100),
      color: colorScheme.background,
      items: List.generate(
        options.length,
        (index) => PopupMenuItem(
          value: index + 1,
          child: Text(
            options[index],
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
      elevation: 8.0,
    ).then((value) {
      val = value;
    });
    return val;
  }

  static Icon getMessageStatusIcon(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "sent":
        return Icon(
          starHalfIcon,
          color: colorScheme.primary,
          size: Dimensions.height17,
        );
      case "sending":
        return Icon(
          clockIcon,
          size: Dimensions.height17,
          color: colorScheme.primary,
        );
      case "received":
        return Icon(
          size: Dimensions.height17,
          starIcon,
          color: colorScheme.primary,
        );
      case "read":
        return Icon(
          size: Dimensions.height17,
          starIcon,
          color: colorScheme.secondary,
        );
      default:
        return Icon(
          starHalfIcon,
          color: colorScheme.primary,
        );
    }
  }
}
