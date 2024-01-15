import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController _numberController = TextEditingController();
  TextEditingController get numberController => _numberController;

  final FocusNode _focusNodes = FocusNode();
  FocusNode get focusNodes => _focusNodes;
  final TextEditingController _codeController = TextEditingController();
  TextEditingController get codeController => _codeController;

  int _codeInputFocus = 0;
  int get codeInputFocus => _codeInputFocus;

  void insertNumber(TextEditingController controller, String value,
      {int? inputfocus}) {
    controller.value = TextEditingValue(
      text: "${controller.text}$value",
    );
    if (inputfocus != null && _codeInputFocus <= verificationCodeLength) {
      _codeInputFocus++;
    }
    notifyListeners();
  }

  void backSpace(TextEditingController controller, {int? inputfocus}) {
    if (controller.text.isNotEmpty) {
      controller.value = TextEditingValue(
        text: controller.text.substring(0, controller.text.length - 1),
      );
    }
    if (inputfocus != null && _codeInputFocus > 0) {
      _codeInputFocus--;
    }
    notifyListeners();
  }

  void clearAll(TextEditingController controller) {
    controller.clear();
    notifyListeners();
  }
}
