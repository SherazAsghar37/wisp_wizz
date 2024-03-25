import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final String? messageStatus;
  final String? repliedToId;
  final String? repliedMessage;
  final String? repliedMessageType;
  final String? senderProfile;
  final String? recipientProfile;
  final String? messageId;
  final String? chatId;

  const MessageEntity(
      {this.senderId,
      this.recipientId,
      this.senderName,
      this.recipientName,
      this.messageType,
      this.message,
      this.createdAt,
      this.messageStatus,
      this.repliedToId,
      this.repliedMessage,
      this.repliedMessageType,
      this.messageId,
      this.senderProfile,
      this.recipientProfile,
      this.chatId});

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        senderName,
        recipientName,
        messageType,
        message,
        createdAt,
        messageStatus,
        repliedToId,
        repliedMessage,
        repliedMessageType,
        messageId,
        senderProfile,
        recipientProfile,
        chatId
      ];
}
