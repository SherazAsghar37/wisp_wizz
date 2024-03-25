import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:wisp_wizz/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';

class ChatRepository implements IChatRepository {
  final ChatRemoteDatasource _remoteDatasource;
  final ChatLocalDatasource _localDatasource;
  const ChatRepository(this._remoteDatasource, this._localDatasource);

  @override
  FutureVoid deleteChat(String chatId) async {
    try {
      final response = await _remoteDatasource.deleteChat(chatId);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  FutureVoid deleteMessage(String messageId) async {
    try {
      final response = await _remoteDatasource.deleteMessage(messageId);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<CustomGetMyChatsResponse> getMyChats(
      int currentPage, String userId) async {
    try {
      final response = await _localDatasource.fetchChats(currentPage, userId);
      return Right(response);
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  FutureVoid updateMessage(MessageModel message) async {
    try {
      final response = await _remoteDatasource.updateMessage(message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  FutureMessage sendMessage({
    required String message,
    required String senderId,
    required String recipientId,
    required String chatId,
    String? repliedToId,
    String? repliedMessage,
  }) async {
    try {
      _remoteDatasource.sendMessage(
        chatId: chatId,
        message: message,
        recipientId: recipientId,
        senderId: senderId,
        repliedToId: repliedToId,
      );
      final response = await _localDatasource.saveMessage(
          chatId: chatId,
          message: message,
          recipientId: recipientId,
          senderId: senderId,
          repliedToId: repliedToId,
          repliedMessage: repliedMessage);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  FutureMessage receivedMessage({
    required String message,
    required String senderId,
    required String recipientId,
    required String chatId,
    required bool isChatClosed,
    required String messageId,
    String? repliedToId,
    String? repliedMessage,
  }) async {
    try {
      final response = await _localDatasource.saveMessage(
          chatId: chatId,
          message: message,
          recipientId: recipientId,
          senderId: senderId,
          repliedToId: repliedToId,
          repliedMessage: repliedMessage,
          messageId: messageId,
          isChatClosed: isChatClosed);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  ResultFuture<ChatModel> getSingleChat(
      {required String recipientId, required String senderId}) async {
    try {
      final response = await _localDatasource.getChat(
          recipientId: recipientId, senderId: senderId);
      return Right(response);
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await _localDatasource.getMessages(chatId);
      return Right(response);
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  Result<void> initChat({
    required String chatId,
  }) {
    try {
      _localDatasource.readMessages(chatId);
      return const Right(null);
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    }
  }

  @override
  Result<void> sendChatStatus(
      {required String? chatId, required String userId}) {
    try {
      _remoteDatasource.sendStatus(chatId, userId);
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }
}
