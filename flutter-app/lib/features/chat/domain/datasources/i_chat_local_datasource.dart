import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';

abstract class IChatLocalDatasource {
  Future<ChatModel> getChat(
      {required String recipientId, required String senderId});
  Future<List<MessageModel>> getMessages(String chatId);
  Future<void> saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId,
      String? repliedMessage,
      String? messageId,
      bool? isChatClosed});
  Future<CustomGetMyChatsResponse> fetchChats(int currentPage, String userId);
  Future<void> readMessages(String chatId);
}
