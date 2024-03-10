import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';

abstract class IChatLocalDatasource {
  void saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId});
  Future<ChatModel> getChat(
      {required String recipientId, required String senderId});
}
