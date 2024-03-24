import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class ReceivedMessageUseCase
    extends UsecaseWithParam<MessageModel, CustomReceivedMessgeParam> {
  final IChatRepository repository;

  ReceivedMessageUseCase({required this.repository});

  @override
  FutureMessage call(CustomReceivedMessgeParam param) {
    return repository.receivedMessage(
        chatId: param.chatId,
        message: param.message,
        recipientId: param.recipientId,
        senderId: param.senderId,
        repliedToId: param.repliedToId,
        repliedMessage: param.repliedToMessage,
        messageId: param.messageId,
        isChatClosed: param.isChatClosed);
  }
}

class CustomReceivedMessgeParam extends Equatable {
  final String message;
  final String messageId;
  final String senderId;
  final String recipientId;
  final String chatId;
  final String? repliedToId;
  final String? repliedToMessage;
  final bool isChatClosed;

  const CustomReceivedMessgeParam({
    required this.message,
    required this.senderId,
    required this.chatId,
    required this.recipientId,
    required this.isChatClosed,
    required this.messageId,
    this.repliedToId,
    this.repliedToMessage,
  });

  @override
  List<Object?> get props => [
        message,
        senderId,
        recipientId,
        chatId,
        repliedToId,
        repliedToMessage,
        messageId,
        isChatClosed,
        messageId
      ];
}
