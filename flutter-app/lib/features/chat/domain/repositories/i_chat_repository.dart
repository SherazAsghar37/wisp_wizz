import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';

abstract class IChatRepository {
  FutureMessage sendMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId,
      String? repliedMessage});
  FutureMessage receivedMessage({
    required String message,
    required String senderId,
    required String recipientId,
    required String chatId,
    String? repliedToId,
    String? repliedMessage,
    String? messageId,
  });
  ResultFuture<List<MessageModel>> getMessages(String chatId);
  ResultFuture<ChatModel> getSingleChat(
      {required String recipientId, required String senderId});
  ResultFuture<List<ChatModel>> getMyChats(int currentPage, String userId);

  FutureVoid deleteMessage(String messageId);
  FutureVoid updateMessage(MessageModel message);
  FutureVoid deleteChat(String chatId);
  // FutureChat getChat
}
