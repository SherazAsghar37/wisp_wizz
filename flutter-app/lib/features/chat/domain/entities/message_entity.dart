import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? messageType;
  final String? message;
  final DateTime? createdAt;
  final bool? isSeen;
  final String? repliedTo;
  final String? repliedMessage;
  final String? repliedMessageType;
  final String? senderProfile;
  final String? recipientProfile;
  final String? messageId;

  const MessageEntity({
    this.senderId,
    this.recipientId,
    this.senderName,
    this.recipientName,
    this.messageType,
    this.message,
    this.createdAt,
    this.isSeen,
    this.repliedTo,
    this.repliedMessage,
    this.repliedMessageType,
    this.messageId,
    this.senderProfile,
    this.recipientProfile,
  });

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        senderName,
        recipientName,
        messageType,
        message,
        createdAt,
        isSeen,
        repliedTo,
        repliedMessage,
        repliedMessageType,
        messageId,
        senderProfile,
        recipientProfile,
      ];
}
