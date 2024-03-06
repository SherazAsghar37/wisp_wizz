// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

class ChatModel extends ChatEntity {
  @override
  final UserModel sender;
  @override
  final String? recentTextMessage;
  @override
  final DateTime? createdAt;
  @override
  final int? totalUnReadMessages;
  @override
  final String chatId;
  @override
  final UserModel recipient;

  const ChatModel(
      {required this.sender,
      this.recentTextMessage,
      this.createdAt,
      this.totalUnReadMessages,
      required this.chatId,
      required this.recipient})
      : super(
            recentTextMessage: recentTextMessage,
            createdAt: createdAt,
            totalUnReadMessages: totalUnReadMessages,
            chatId: chatId,
            recipient: recipient);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender.toMap(),
      'recentTextMessage': recentTextMessage,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'totalUnReadMessages': totalUnReadMessages,
      'id': chatId,
      "recipient": recipient.toMap()
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : this(
          sender: UserModel.fromMap(map['sender']),
          recentTextMessage: map['recentTextMessage'],
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
          totalUnReadMessages: map['totalUnReadMessages'],
          chatId: map['id'],
          recipient: UserModel.fromMap(map['recipient']),
        );

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatModel.empty()
      : this(
          sender: UserModel.empty(),
          recentTextMessage: "hi testing message",
          createdAt: DateTime.now(),
          totalUnReadMessages: 4,
          chatId: "12ab",
          recipient: UserModel.empty(),
        );

  ChatModel copyWith({
    String? senderId,
    String? recipientId,
    String? senderName,
    String? recipientName,
    String? recentTextMessage,
    DateTime? createdAt,
    String? senderProfile,
    String? recipientProfile,
    int? totalUnReadMessages,
    String? chatId,
    UserModel? sender,
  }) {
    return ChatModel(
      sender: this.sender,
      recentTextMessage: recentTextMessage ?? this.recentTextMessage,
      createdAt: createdAt ?? this.createdAt,
      totalUnReadMessages: totalUnReadMessages ?? this.totalUnReadMessages,
      chatId: chatId ?? this.chatId,
      recipient: recipient,
    );
  }
}
