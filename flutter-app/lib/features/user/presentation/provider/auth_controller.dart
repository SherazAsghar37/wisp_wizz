import 'dart:async';

import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class AuthController extends ChangeNotifier {
  Timer? _timer;
  Timer? get timer => _timer;
  int _secondsRemaining = 60;
  int get secondsRemaining => _secondsRemaining;
  void startTimer() {
    _secondsRemaining = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_secondsRemaining == 0) {
          timer.cancel();
        } else {
          _secondsRemaining--;
          notifyListeners();
        }
      },
    );
  }
}
