import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';

abstract class IChatRemoteDatasource {
  void sendMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId});
  Stream<List<ChatModel>> getMyChats(String userId);
  Stream<List<MessageModel>> getMessages(String chatId);
  Future<void> deleteMessage(String messageId);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteChat(String chatId);
}
