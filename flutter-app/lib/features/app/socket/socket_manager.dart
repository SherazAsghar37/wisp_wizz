import 'dart:async';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';

class WebSocketManager {
  static late IO.Socket _socket;
  static IO.Socket get socket => _socket;
  static Future<bool> socketInit() async {
    Completer<bool> completer = Completer<bool>();
    _socket = IO.io(socketIOBaseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true
    });
    _socket.onConnect((_) {
      DebugHelper.printWarning('connect');
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });
    _socket.onDisconnect((_) {
      DebugHelper.printWarning('disconnected');
    });
    _socket.onerror((error) {
      DebugHelper.printError(error);
      throw SocketException(error);
    });
    _socket.onConnectError((data) {
      DebugHelper.printError(data);
      throw SocketException(data);
    });
    _socket.onConnectTimeout((data) {
      DebugHelper.printError(data);
      throw SocketException(data);
    });
    _socket.connect();
    DebugHelper.printWarning("here");
    return completer.future;
  }

  // static Future<void> connect() async {
  //   Completer completer = Completer<void>();
  //   _socket = IO.io(baseUrl, <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoConnect": true
  //   });
  //   _socket.onConnect((_) {
  //     DebugHelper.printWarning('connect');
  //     completer.complete();
  //   });
  //   _socket.onDisconnect((_) => DebugHelper.printWarning('disconnected'));
  //   _socket.connect().onError((data) => print(data));
  //   DebugHelper.printWarning("here");
  //   return completer.future;
  // }
}
