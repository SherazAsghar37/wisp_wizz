import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/helper/dimensions.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

class Utils {
  static Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  static ImageProvider<Object> getUserImage(UserModel user) {
    try {
      return Image.network(baseUrl + user.image).image;
    } catch (e) {
      DebugHelper.printError("Loading User Model Image Error : $e");
      return Image.asset("images/profile.png").image;
    }
  }

  static ImageProvider<Object> getUserImageFromUint8List(
      Uint8List? image, String? imageUrl) {
    try {
      return image == null
          ? imageUrl == null
              ? Image.asset(
                  "images/profile.png",
                  fit: BoxFit.cover,
                ).image
              : Image.network(baseUrl + imageUrl).image
          : Image.memory(
              image,
              fit: BoxFit.cover,
            ).image;
    } catch (e) {
      DebugHelper.printError("Loading Uint8List Image Error : $e");
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
}
