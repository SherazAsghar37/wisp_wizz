// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

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
  @override
  final UserModel recipient;

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
      required this.chatId,
      required this.recipient})
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
            chatId: chatId,
            recipient: recipient);

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
      'id': chatId,
      "recipient": recipient.toMap()
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
          chatId: map['id'],
          recipient: UserModel.fromMap(map['recipient']),
        );

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatModel.empty()
      : this(
          senderId: "abc",
          recipientId: "xyz",
          senderName: "sheraz",
          recipientName: "user",
          recentTextMessage: "hi testing message",
          createdAt: DateTime.now(),
          senderProfile: "as",
          recipientProfile: "Asd",
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
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      senderName: senderName ?? this.senderName,
      recipientName: recipientName ?? this.recipientName,
      recentTextMessage: recentTextMessage ?? this.recentTextMessage,
      createdAt: createdAt ?? this.createdAt,
      senderProfile: senderProfile ?? this.senderProfile,
      recipientProfile: recipientProfile ?? this.recipientProfile,
      totalUnReadMessages: totalUnReadMessages ?? this.totalUnReadMessages,
      chatId: chatId ?? this.chatId,
      recipient: recipient,
    );
  }
}
