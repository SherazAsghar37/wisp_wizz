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
  final String? repliedTo;
  final String? repliedToId;

  const SendMessageEvent(
      {required this.senderId,
      required this.recipientId,
      required this.message,
      required this.chatId,
      this.repliedTo,
      this.repliedToId});

  @override
  List<Object?> get props =>
      [senderId, recipientId, message, chatId, repliedTo, repliedToId];
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
