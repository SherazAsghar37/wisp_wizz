import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';

class WebSocketManager {
  static late IO.Socket _socket;
  static IO.Socket get socket => _socket;
  static void socketInit(String userId) {
    try {
      DebugHelper.printWarning("Socket called");
      _socket = IO.io(socketIOBaseUrl, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true
      }).connect();
      _socket.onConnect((_) {
        _socket.emit("login", userId);
      });
      _socket.onDisconnect((_) {
        DebugHelper.printWarning('disconnected');
      });
      _socket.onerror((error) {
        DebugHelper.printError("onerror $error");
        // throw WebSocketException(error.toString());
      });
      _socket.onConnectError((data) {
        DebugHelper.printError("onConnectError $data");
        // throw WebSocketException(data.toString());
      });
      _socket.onConnectTimeout((data) {
        DebugHelper.printError("onConnectTimeout $data");
        // throw WebSocketException(data.toString());
      });
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw WebSocketException(e.toString());
    }
  }

  static void emitMesssage(dynamic data) => _socket.emit("message", data);
  static void disconnect() => _socket.disconnect();
}
