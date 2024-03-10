import 'package:wisp_wizz/features/app/socket/socket_manager.dart';

class WebSocketManagerWrapper {
  Future<bool> initSocket() {
    return WebSocketManager.socketInit();
  }
}
