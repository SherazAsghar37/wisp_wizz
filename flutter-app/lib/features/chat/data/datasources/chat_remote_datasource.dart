import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/datasources/i_chat_remote_datasource.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

class ChatRemoteDatasource implements IChatRemoteDatasource {
  @override
  Future<void> deleteChat(ChatEntity chat) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMessage(MessageEntity message) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> getMessages(MessageEntity message) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatModel>> getMyChat(ChatEntity chat) {
    // TODO: implement getMyChat
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(MessageEntity message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }
}
