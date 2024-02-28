import 'dart:async';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/theme/theme.dart';

class MainController extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;

  void changeTheme() {
    _themeData = _themeData == darkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }

  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  Future<void> connectSocket() async {
    // Completer completer = Completer<void>();
    _socket = IO.io(baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });
    _socket.onConnect((_) {
      DebugHelper.printWarning('connect');
      socket.emit('msg', 'test');
      // completer.complete();
    });
    _socket.on('event', (data) => DebugHelper.printWarning(data));
    _socket.onDisconnect((_) => DebugHelper.printWarning('disconnect'));
    _socket.on('fromServer', (_) => DebugHelper.printWarning(_));
    DebugHelper.printWarning("here");
    // return completer.future;
  }
}
