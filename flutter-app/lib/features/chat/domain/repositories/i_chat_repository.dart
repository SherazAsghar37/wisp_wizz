import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';

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
    required bool isChatClosed,
    required String messageId,
    String? repliedToId,
    String? repliedMessage,
  });
  ResultFuture<List<MessageModel>> getMessages(String chatId);
  ResultFuture<ChatModel> getSingleChat(
      {required String recipientId, required String senderId});
  ResultFuture<CustomGetMyChatsResponse> getMyChats(
      int currentPage, String userId);

  FutureVoid deleteMessage(String messageId);
  FutureVoid updateMessage(MessageModel message);
  FutureVoid deleteChat(String chatId);
  Result<void> initChat({required String chatId});
  Result<void> sendChatStatus({
    required String? chatId,
    required String userId,
  });
  // FutureChat getChat
}
