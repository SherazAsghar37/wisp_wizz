import 'package:wisp_wizz/features/app/socket/socket_manager.dart';

class WebSocketManagerWrapper {
  void initSocket(String userId) => WebSocketManager.socketInit(userId);
  void disconnect() => WebSocketManager.disconnect();
}
