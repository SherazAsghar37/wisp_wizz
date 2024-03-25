import 'dart:developer';

import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager_wrapper.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/datasources/i_chat_local_datasource.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';

class ChatLocalDatasource extends IChatLocalDatasource {
  final SqfliteManagerWrapper _sqfliteManagerWrapper;
  ChatLocalDatasource({required SqfliteManagerWrapper sqfliteManagerWrapper})
      : _sqfliteManagerWrapper = sqfliteManagerWrapper;

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
    bool? isChatClosed,
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

      final res = await _sqfliteManagerWrapper.insertMessage(
          data, isChatClosed ?? false);

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
  Future<CustomGetMyChatsResponse> fetchChats(
      int currentPage, String userId) async {
    try {
      final res = await _sqfliteManagerWrapper.fetchChats(userId, currentPage);
      return CustomGetMyChatsResponse(
          totalUnreadMessages: res["totalUnreadMessages"],
          chats: List<ChatModel>.from(
              res["data"].map((e) => ChatModel.fromDBData(e)).toList()));
    } on SqfliteDBException catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException(
          "Something went wrong, Unable to fetch your chats");
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Something went wrong");
    }
  }

  @override
  Future<void> readMessages(String chatId) async {
    try {
      await _sqfliteManagerWrapper.removeUnreadMarkFromChat(chatId);
    } on SqfliteDBException catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException(
          "Something went wrong, Unable to fetch your messages");
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Something went wrong");
    }
  }
}
