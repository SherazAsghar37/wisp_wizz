import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';

abstract class IChatLocalDatasource {
  // void saveMessage(
  //     {required String message,
  //     required String senderId,
  //     required String recipientId,
  //     required String chatId,
  //     String? repliedToId});
  Future<ChatModel> getChat(
      {required String recipientId, required String senderId});
  Future<List<MessageModel>> getMessages(String chatId);
  Future<void> saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId});
  Future<List<ChatModel>> fetchChats(int currentPage, String userId);
}
