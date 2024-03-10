// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

class ChatModel extends ChatEntity {
  @override
  final String senderId;
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
  @override
  final List<MessageModel> messages;

  const ChatModel(
      {required this.senderId,
      this.recentTextMessage,
      this.createdAt,
      this.totalUnReadMessages,
      required this.chatId,
      required this.recipient,
      required this.messages})
      : super(
            recentTextMessage: recentTextMessage,
            createdAt: createdAt,
            totalUnReadMessages: totalUnReadMessages,
            chatId: chatId,
            recipient: recipient,
            messages: messages,
            senderId: senderId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recentTextMessage': recentTextMessage,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'totalUnReadMessages': totalUnReadMessages,
      'id': chatId,
      "recipient": recipient.toString(),
      "messages": messages.map((e) => e.toMap())
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : this(
            senderId: map['senderId'],
            recentTextMessage: "map['recentTextMessage']",
            createdAt:
                DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
            totalUnReadMessages: map['unreadMessages'],
            chatId: map['id'],
            recipient: UserModel.fromMap(map['sender']),
            messages: map['messages'].isNotEmpty
                ? List<MessageModel>.from(map['messages']
                    .map((e) => MessageModel.fromMap(e))
                    .toList())
                : []);

  ChatModel.fromDBData(Map<String, dynamic> map)
      : this(
            senderId: map['senderId'],
            recentTextMessage: "map['recentTextMessage']",
            createdAt: DateTime.parse(map['createdAt']),
            totalUnReadMessages: map['unreadMessages'],
            chatId: map['id'],
            recipient: UserModel(
                name: map["name"],
                phoneNumber: map["phoneNumber"],
                id: map["id"],
                status: map["status"] == 1 ? true : false,
                lastSeen: DateTime.parse(map["lastSeen"]),
                image: base64Decode(map["image"])),
            messages: map['messages'].isNotEmpty
                ? List<MessageModel>.from(map['messages']
                    .map((e) => MessageModel.fromMap(e))
                    .toList())
                : []);
  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatModel.empty()
      : this(
            senderId: "asfasf",
            recentTextMessage: "hi testing message",
            createdAt: DateTime.now(),
            totalUnReadMessages: 4,
            chatId: "12ab",
            recipient: UserModel.empty(),
            messages: [MessageModel.empty()]);

  ChatModel copyWith(
      {UserModel? recipient,
      String? recentTextMessage,
      DateTime? createdAt,
      int? totalUnReadMessages,
      String? chatId,
      String? senderId,
      List<MessageModel>? messages}) {
    return ChatModel(
        senderId: senderId ?? this.senderId,
        recentTextMessage: recentTextMessage ?? this.recentTextMessage,
        createdAt: createdAt ?? this.createdAt,
        totalUnReadMessages: totalUnReadMessages ?? this.totalUnReadMessages,
        chatId: chatId ?? this.chatId,
        recipient: recipient ?? this.recipient,
        messages: messages ?? this.messages);
  }
}
