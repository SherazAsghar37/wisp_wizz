import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

abstract class IChatRepository {
  FutureVoid sendMessage(ChatEntity chat, MessageEntity message);
  ResultStreamList<ChatEntity> getMyChat(ChatEntity chat);
  ResultStreamList<MessageEntity> getMessages(MessageEntity message);
  FutureVoid deleteMessage(MessageEntity message);
  FutureVoid updateMessage(MessageEntity message);
  FutureVoid deleteChat(ChatEntity chat);
}
