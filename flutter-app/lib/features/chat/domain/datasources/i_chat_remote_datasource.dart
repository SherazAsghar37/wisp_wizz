import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

abstract class IChatRemoteDatasource {
  Future<void> sendMessage(ChatEntity chat, MessageEntity message);
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat);
  Stream<List<MessageEntity>> getMessages(MessageEntity message);
  Future<void> deleteMessage(MessageEntity message);
  Future<void> updateMessage(MessageEntity message);
  Future<void> deleteChat(ChatEntity chat);
}
