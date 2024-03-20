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
  final MessageModel? lastMessage;

  const ChatModel(
      {required this.senderId,
      this.recentTextMessage,
      this.createdAt,
      this.totalUnReadMessages,
      required this.chatId,
      required this.recipient,
      required this.lastMessage})
      : super(
            recentTextMessage: recentTextMessage,
            createdAt: createdAt,
            totalUnReadMessages: totalUnReadMessages,
            chatId: chatId,
            recipient: recipient,
            lastMessage: lastMessage,
            senderId: senderId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recentTextMessage': recentTextMessage,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'totalUnReadMessages': totalUnReadMessages,
      'id': chatId,
      "recipient": recipient.toString(),
      "lastMessage": lastMessage?.toMap()
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
            lastMessage: map['lastMessage'] != null
                ? MessageModel.fromMap(map['lastMessage'])
                : null);

  ChatModel.fromDBData(Map<String, dynamic> map)
      : this(
            senderId: map['senderId'],
            recentTextMessage: "map['recentTextMessage']",
            createdAt: DateTime.parse(map['createdAt']),
            totalUnReadMessages: map['unreadMessages'],
            chatId: map['chatId'],
            recipient: UserModel(
                name: map["name"],
                phoneNumber: map["phoneNumber"],
                id: map["id"],
                status: map["status"] == 1 ? true : false,
                lastSeen: DateTime.parse(map["lastSeen"]),
                image: base64Decode(map["image"])),
            lastMessage: map["messageId"] != null
                ? MessageModel(
                    senderId: map['senderId'],
                    recipientId: map['recipientId'],
                    message: map["message"],
                    messageStatus: map["messageStatus"],
                    createdAt: DateTime.parse(map["sentAt"]),
                    messageId: map['messageId'],
                    chatId: map['chatId'])
                : null);
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
            lastMessage: MessageModel.empty());

  ChatModel copyWith(
      {UserModel? recipient,
      String? recentTextMessage,
      DateTime? createdAt,
      int? totalUnReadMessages,
      String? chatId,
      String? senderId,
      MessageModel? lastMessage}) {
    return ChatModel(
        senderId: senderId ?? this.senderId,
        recentTextMessage: recentTextMessage ?? this.recentTextMessage,
        createdAt: createdAt ?? this.createdAt,
        totalUnReadMessages: totalUnReadMessages ?? this.totalUnReadMessages,
        chatId: chatId ?? this.chatId,
        recipient: recipient ?? this.recipient,
        lastMessage: lastMessage ?? this.lastMessage);
  }
}
