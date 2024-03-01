import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';

abstract class IChatRepository {
  ResultVoid sendMessage(MessageModel message);
  ResultStreamList<ChatModel> getMyChats(String userId);
  ResultStreamList<MessageModel> getMessages(String chatId);
  FutureVoid deleteMessage(String messageId);
  FutureVoid updateMessage(MessageModel message);
  FutureVoid deleteChat(String chatId);
}
