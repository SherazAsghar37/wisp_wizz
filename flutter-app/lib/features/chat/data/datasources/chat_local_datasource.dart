import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager_wrapper.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/domain/datasources/i_chat_local_datasource.dart';

class ChatLocalDatasource extends IChatLocalDatasource {
  final SqfliteManagerWrapper _sqfliteManagerWrapper;
  ChatLocalDatasource({required SqfliteManagerWrapper sqfliteManagerWrapper})
      : _sqfliteManagerWrapper = sqfliteManagerWrapper;
  @override
  void saveMessage(
      {required String message,
      required String senderId,
      required String recipientId,
      required String chatId,
      String? repliedToId}) {
    try {
      _sqfliteManagerWrapper.saveMessage(
          recipientId: recipientId, senderId: senderId, message: message);
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Unable to send message");
    }
  }

  @override
  Future<String> getChat(
      {required String recipientId, required String senderId}) async {
    try {
      return _sqfliteManagerWrapper.fetchChat(recipientId, senderId);
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const SqfliteDBException("Unable to send message");
    }
  }
}
