import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class ChatRepository implements IChatRepository {
  final ChatRemoteDatasource _remoteDatasource;
  const ChatRepository(this._remoteDatasource);

  @override
  ResultVoid sendMessage(MessageModel message) {
    try {
      final response = _remoteDatasource.sendMessage(message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

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
  ResultStreamList<MessageModel> getMessages(String chatId) {
    try {
      final response = _remoteDatasource.getMessages(chatId);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultStreamList<ChatModel> getMyChats(String userId) {
    try {
      final response = _remoteDatasource.getMyChats(userId);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
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
}
