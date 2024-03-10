import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendMessageUseCase
    extends UsecaseWithParamSync<void, CustomSendMessgeParam> {
  final IChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  ResultVoid call(CustomSendMessgeParam param) {
    return repository.sendMessage(
        chatId: param.chatId,
        message: param.message,
        recipientId: param.recipientId,
        senderId: param.senderId,
        repliedToId: param.repliedToId);
  }
}

class CustomSendMessgeParam extends Equatable {
  final String message;
  final String senderId;
  final String recipientId;
  final String chatId;
  final String? repliedToId;
  const CustomSendMessgeParam(
      {required this.message,
      required this.senderId,
      required this.chatId,
      required this.recipientId,
      this.repliedToId});

  @override
  List<Object?> get props =>
      [message, senderId, recipientId, chatId, repliedToId];
}
