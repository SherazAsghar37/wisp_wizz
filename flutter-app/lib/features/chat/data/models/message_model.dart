// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  @override
  final String? senderId;
  @override
  final String? recipientId;
  @override
  final String? senderName;
  @override
  final String? recipientName;
  @override
  final String? messageType;
  @override
  final String? message;
  @override
  final DateTime? createdAt;
  @override
  final bool? isSeen;
  @override
  final String? repliedTo;
  @override
  final String? repliedMessage;
  @override
  final String? repliedMessageType;
  @override
  final String? messageId;

  const MessageModel(
      {this.senderId,
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
      this.messageId})
      : super(
            senderId: senderId,
            recipientId: recipientId,
            senderName: senderName,
            recipientName: recipientName,
            message: message,
            messageType: messageType,
            messageId: messageId,
            createdAt: createdAt,
            isSeen: isSeen,
            repliedTo: repliedTo,
            repliedMessage: repliedMessage,
            repliedMessageType: repliedMessageType);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recipientId': recipientId,
      'senderName': senderName,
      'recipientName': recipientName,
      'messageType': messageType,
      'message': message,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'repliedTo': repliedTo,
      'repliedMessage': repliedMessage,
      'repliedMessageType': repliedMessageType,
      '_id': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      recipientId: map['recipientId'],
      senderName: map['senderName'],
      recipientName: map['recipientName']!,
      messageType: map['messageType']!,
      message: map['message'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      isSeen: map['isSeen'],
      repliedTo: map['repliedTo'],
      repliedMessage: map['repliedMessage'],
      repliedMessageType: map['repliedMessageType'],
      messageId: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
