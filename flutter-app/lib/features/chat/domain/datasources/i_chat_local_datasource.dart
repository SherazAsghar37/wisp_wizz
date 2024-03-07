abstract class IChatLocalDatasource {
  void saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId});
  Future<String> getChat(
      {required String recipientId, required String senderId});
}
