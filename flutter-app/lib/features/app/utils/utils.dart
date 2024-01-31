import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class Utils {
  static ImageProvider<Object> getUserImage(UserModel user) {
    if (user.image != null) {
      return Image.file(File(user.image!)).image;
    } else {
      return Image.asset("images/profile.png").image;
    }
  }
}
