import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';

class WebSocketManager {
  static late IO.Socket _socket;
  static IO.Socket get socket => _socket;
  static void socketInit(String userId) {
    DebugHelper.printWarning("Called");
    _socket = IO.io(socketIOBaseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true
    });
    _socket.onConnect((_) {
      DebugHelper.printWarning('$_ connect');
      _socket.emit("login", userId);
    });
    _socket.onDisconnect((_) {
      DebugHelper.printWarning('disconnected');
    });
    _socket.onerror((error) {
      DebugHelper.printError(error);
      throw WebSocketException(error);
    });
    _socket.onConnectError((data) {
      DebugHelper.printError(data);
      throw WebSocketException(data);
    });
    _socket.onConnectTimeout((data) {
      DebugHelper.printError(data);
      throw WebSocketException(data);
    });

    _socket.connect();
  }

  static void emitMesssage(dynamic data) => _socket.emit("message", data);
  static void disconnect() => _socket.disconnect();
}
