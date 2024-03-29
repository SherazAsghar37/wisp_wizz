import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendMessageUseCase
    extends UsecaseWithParam<MessageModel, CustomSendMessgeParam> {
  final IChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  FutureMessage call(CustomSendMessgeParam param) {
    return repository.sendMessage(
        chatId: param.chatId,
        message: param.message,
        recipientId: param.recipientId,
        senderId: param.senderId,
        repliedToId: param.repliedToId,
        repliedMessage: param.repliedToMessage);
  }
}

class CustomSendMessgeParam extends Equatable {
  final String message;
  final String senderId;
  final String recipientId;
  final String chatId;
  final String? repliedToId;
  final String? repliedToMessage;
  const CustomSendMessgeParam(
      {required this.message,
      required this.senderId,
      required this.chatId,
      required this.recipientId,
      this.repliedToId,
      this.repliedToMessage});

  @override
  List<Object?> get props =>
      [message, senderId, recipientId, chatId, repliedToId, repliedToMessage];
}
