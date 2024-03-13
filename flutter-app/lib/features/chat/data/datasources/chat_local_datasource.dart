import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager_wrapper.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/datasources/i_chat_local_datasource.dart';

class ChatLocalDatasource extends IChatLocalDatasource {
  final SqfliteManagerWrapper _sqfliteManagerWrapper;
  ChatLocalDatasource({required SqfliteManagerWrapper sqfliteManagerWrapper})
      : _sqfliteManagerWrapper = sqfliteManagerWrapper;
  // @override
  // void saveMessage(
  //     {required String message,
  //     required String senderId,
  //     required String recipientId,
  //     required String chatId,
  //     String? repliedToId}) {
  //   try {
  //     _sqfliteManagerWrapper.saveMessage(
  //         recipientId: recipientId, senderId: senderId, message: message);
  //   } catch (e) {
  //     DebugHelper.printError(e.toString());
  //     throw const SqfliteDBException("Unable to send message");
  //   }
  // }

  @override
  Future<ChatModel> getChat(
      {required String recipientId, required String senderId}) async {
    try {
      final queryData =
          await _sqfliteManagerWrapper.fetchChat(recipientId, senderId);
      return ChatModel.fromDBData(queryData);
    } on SqfliteDBException catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Unable to establish chat");
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Something went wrong");
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await _sqfliteManagerWrapper.fetchMessages(chatId);
      List<MessageModel> messages =
          List<MessageModel>.from(response.map((e) => MessageModel.fromMap(e)));
      return messages;
    } catch (e) {
      throw const WebSocketException(
          "Something went wrong, Unable to load messages");
    }
  }

  @override
  Future<MessageModel> saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId}) async {
    try {
      final data = {
        "message": message,
        "chatId": chatId,
        "messageStatus": "Sent",
        "repliedToId": repliedToId,
        "createdAt": DateTime.now().toIso8601String()
      };
      final res = await _sqfliteManagerWrapper.insertMessage(data);
      return MessageModel.fromMap({
        ...res,
        "senderId": senderId,
        "recipientId": recipientId,
      });
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException(
          "Something went wrong, Unable to send message");
    }
  }
}
