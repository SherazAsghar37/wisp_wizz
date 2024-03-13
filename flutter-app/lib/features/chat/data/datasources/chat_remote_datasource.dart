import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/datasources/i_chat_remote_datasource.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class ChatRemoteDatasource implements IChatRemoteDatasource {
  final io.Socket _socket;
  const ChatRemoteDatasource({
    required io.Socket socket,
  }) : _socket = socket;

  @override
  void sendMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId}) {
    try {
      final data = {
        "message": message,
        "senderId": senderId,
        "recipientId": recipientId,
        "chatId": chatId,
        "repliedToId": repliedToId,
      };
      return _socket.emit("message", data);
    } catch (e) {
      throw const WebSocketException(
          "Something went wrong, Unable to send message");
    }
  }

  @override
  Future<void> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessage(String messageId) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatModel>> getMyChats(String userId) {
    // TODO: implement getMyChats
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(MessageModel message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }
}
