import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class ChatRepository implements IChatRepository {
  final ChatRemoteDatasource _remoteDatasource;
  const ChatRepository(this._remoteDatasource);

  @override
  FutureVoid deleteChat(ChatEntity chat) async {
    try {
      final response = await _remoteDatasource.deleteChat(chat);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  FutureVoid deleteMessage(MessageEntity message) async {
    try {
      final response = await _remoteDatasource.deleteMessage(message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultStreamList<MessageModel> getMessages(MessageEntity message) {
    try {
      final response = _remoteDatasource.getMessages(message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultStreamList<ChatModel> getMyChat(ChatEntity chat) {
    try {
      final response = _remoteDatasource.getMyChat(chat);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  FutureVoid sendMessage(ChatEntity chat, MessageEntity message) async {
    try {
      final response = await _remoteDatasource.sendMessage(chat, message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  FutureVoid updateMessage(MessageEntity message) async {
    try {
      final response = await _remoteDatasource.updateMessage(message);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
