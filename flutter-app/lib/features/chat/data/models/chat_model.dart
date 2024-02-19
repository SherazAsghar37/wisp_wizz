// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  @override
  final String? senderId;
  @override
  final String? recipientId;
  @override
  final String? senderName;
  @override
  final String? recipientName;
  @override
  final String? recentTextMessage;
  @override
  final DateTime? createdAt;
  @override
  final String? senderProfile;
  @override
  final String? recipientProfile;
  @override
  final int? totalUnReadMessages;
  @override
  final String chatId;

  const ChatModel(
      {this.senderId,
      this.recipientId,
      this.senderName,
      this.recipientName,
      this.recentTextMessage,
      this.createdAt,
      this.senderProfile,
      this.recipientProfile,
      this.totalUnReadMessages,
      required this.chatId})
      : super(
            senderId: senderId,
            recipientId: recipientId,
            senderName: senderName,
            recipientName: recipientName,
            senderProfile: senderProfile,
            recipientProfile: recipientProfile,
            recentTextMessage: recentTextMessage,
            createdAt: createdAt,
            totalUnReadMessages: totalUnReadMessages,
            chatId: chatId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recipientId': recipientId,
      'senderName': senderName,
      'recipientName': recipientName,
      'recentTextMessage': recentTextMessage,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'senderProfile': senderProfile,
      'recipientProfile': recipientProfile,
      'totalUnReadMessages': totalUnReadMessages,
      '_id': chatId,
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : this(
          senderId: map['senderId'],
          recipientId: map['recipientId'],
          senderName: map['senderName'],
          recipientName: map['recipientName'],
          recentTextMessage: map['recentTextMessage'],
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
          senderProfile: map['senderProfile'],
          recipientProfile: map['recipientProfile'],
          totalUnReadMessages: map['totalUnReadMessages'],
          chatId: map['_id'],
        );

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
