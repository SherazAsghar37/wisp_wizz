part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends MessageEvent {
  final String senderId;
  final String recipientId;
  final String message;
  final String chatId;
  final String? repliedMessage;
  final String? repliedToId;

  const SendMessageEvent({
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.chatId,
    this.repliedMessage,
    this.repliedToId,
  });

  @override
  List<Object?> get props =>
      [senderId, recipientId, message, chatId, repliedMessage, repliedToId];
}

class ReceivedMessageEvent extends MessageEvent {
  final String senderId;
  final String recipientId;
  final String message;
  final String chatId;
  final String? repliedMessage;
  final String? repliedToId;
  final String? messageId;

  const ReceivedMessageEvent(
      {required this.senderId,
      required this.recipientId,
      required this.message,
      required this.chatId,
      this.repliedMessage,
      this.repliedToId,
      this.messageId});

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        message,
        chatId,
        repliedMessage,
        repliedToId,
        messageId
      ];
}

class FetchMessagesEvent extends MessageEvent {
  final String chatId;

  const FetchMessagesEvent({
    required this.chatId,
  });

  @override
  List<Object?> get props => [
        chatId,
      ];
}
