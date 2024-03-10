import 'package:flutter/material.dart';

import 'package:wisp_wizz/features/app/theme/theme.dart';

class MainController extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;

  void changeTheme() {
    _themeData = _themeData == darkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }
}
