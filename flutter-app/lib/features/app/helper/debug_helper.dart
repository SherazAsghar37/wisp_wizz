import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

class DebugHelper {
  static void printWarning(String text) {
    debugPrint('\x1B[33m$text\x1B[0m');
  }

  static printError(String text) {
    debugPrint('\x1B[31m$text\x1B[0m');
  }
}
