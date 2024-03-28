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
  // final List<MessageModel> messages;

  const SendMessageEvent({
    // required this.messages,
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.chatId,
    this.repliedMessage,
    this.repliedToId,
  });

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        message,
        chatId,
        repliedMessage,
        repliedToId,
        // messages
      ];
}

class ReceivedMessageEvent extends MessageEvent {
  final String senderId;
  final String recipientId;
  final String message;
  final String chatId;
  final String? repliedMessage;
  final String? repliedToId;
  final String messageId;
  final bool isChatClosed;
  final int index;

  const ReceivedMessageEvent({
    required this.senderId,
    required this.messageId,
    required this.recipientId,
    required this.message,
    required this.chatId,
    required this.isChatClosed,
    required this.index,
    this.repliedMessage,
    this.repliedToId,
  });

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        message,
        chatId,
        repliedMessage,
        repliedToId,
        messageId,
        isChatClosed,
        index
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

// class InitMessagesEvent extends MessageEvent {
//   final List<MessageModel> messages;
//   const InitMessagesEvent({required this.messages});
//   @override
//   List<Object?> get props => [
//         messages,
//       ];
// }
