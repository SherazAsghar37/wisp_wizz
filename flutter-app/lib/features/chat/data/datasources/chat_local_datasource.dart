import 'dart:developer';

import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager_wrapper.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
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
      List<MessageModel> messages = List<MessageModel>.from(
          response.map((e) => MessageModel.fromDBData(e)));
      return messages;
    } on SqfliteDBException catch (e) {
      DebugHelper.printError("SqfliteDBException$e");
      throw const SqfliteDBException(
          "Something went wrong, Unable to load messages");
    } catch (e) {
      DebugHelper.printError("Internal Error : $e");
      throw const SqfliteDBException("Something went wrong");
    }
  }

  @override
  Future<MessageModel> saveMessage({
    required String message,
    required String senderId,
    required String recipientId,
    required String chatId,
    String? repliedToId,
    String? repliedMessage,
    String? messageId,
  }) async {
    try {
      final data = {
        "message": message,
        "chatId": chatId,
        "messageStatus": "Sent",
        "repliedToId": repliedToId,
        "senderId": senderId,
        "recipientId": recipientId,
        "createdAt": DateTime.now().toSqfliteFormat(),
        "messageId": messageId,
      };

      final res = await _sqfliteManagerWrapper.insertMessage(data);

      final newData = {...res, "repliedMessage": repliedMessage};
      log(res.toString());
      return MessageModel.fromDBData(newData);
    } on SqfliteDBException catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException(
          "Something went wrong, Unable to send message");
    } catch (e) {
      DebugHelper.printError("Internal error $e");
      throw const SqfliteDBException("Something went wrong");
    }
  }

  @override
  Future<List<ChatModel>> fetchChats(int currentPage, String userId) async {
    try {
      final res = await _sqfliteManagerWrapper.fetchChats(userId, currentPage);
      return res.map((e) => ChatModel.fromDBData(e)).toList();
    } on SqfliteDBException catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException(
          "Something went wrong, Unable to fetch your chats");
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Something went wrong");
    }
  }
}
