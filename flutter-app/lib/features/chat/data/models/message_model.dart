// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  @override
  final String recipientId;
  @override
  final String senderId;
  @override
  final String chatId;
  @override
  final String message;
  @override
  final String messageStatus;
  @override
  final String? repliedToId;
  @override
  final DateTime createdAt;
  @override
  final String? repliedMessage;
  @override
  final String messageId;

  const MessageModel(
      {required this.senderId,
      required this.recipientId,
      this.repliedToId,
      required this.message,
      required this.messageStatus,
      this.repliedMessage,
      required this.createdAt,
      required this.messageId,
      required this.chatId})
      : super(
            senderId: senderId,
            recipientId: recipientId,
            message: message,
            messageId: messageId,
            messageStatus: messageStatus,
            repliedMessage: repliedMessage,
            createdAt: createdAt,
            repliedToId: repliedToId,
            chatId: chatId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recipientId': recipientId,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'messageStatus': messageStatus,
      'repliedToId': repliedToId,
      'repliedMessage': repliedMessage,
      'messageId': messageId,
      'chatId': chatId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      chatId: map['chatId'],
      recipientId: map['recipientId'],
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
      messageStatus: map['messageStatus'],
      repliedToId: map['repliedToId'],
      repliedMessage: map['repliedMessage'],
      messageId: map['messageId'],
    );
  }

  factory MessageModel.fromDBData(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      chatId: map['chatId'],
      recipientId: map['recipientId'],
      message: map['message'],
      createdAt: DateFormatter.fromSqfliteFormat(map['createdAt']),
      messageStatus: map['messageStatus'],
      repliedToId: map['repliedToId'],
      repliedMessage: map['repliedMessage'],
      messageId: map['messageId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
  MessageModel.empty()
      : this(
            createdAt: DateTime.now(),
            messageStatus: "sent",
            message: "message",
            messageId: "asf123fa23afsf1",
            recipientId: "2",
            repliedMessage: null,
            senderId: "1",
            chatId: "2");

  MessageModel copyWith(
      {String? senderId,
      String? recipientId,
      String? senderName,
      String? recipientName,
      String? messageType,
      String? message,
      DateTime? createdAt,
      String? messageStatus,
      String? repliedTo,
      String? repliedMessage,
      String? repliedMessageType,
      String? messageId,
      String? chatId}) {
    return MessageModel(
        senderId: senderId ?? this.senderId,
        recipientId: recipientId ?? this.recipientId,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        messageStatus: messageStatus ?? this.messageStatus,
        repliedMessage: repliedMessage ?? this.repliedMessage,
        messageId: messageId ?? this.messageId,
        chatId: chatId ?? this.chatId);
  }
}
