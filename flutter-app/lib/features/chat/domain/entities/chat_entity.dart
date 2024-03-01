// ignore_for_file: unused_field

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/shared/entities/user_entity.dart';

class ChatEntity extends Equatable {
  final String? senderId;
  final String? recipientId;
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final int? totalUnReadMessages;
  final String? chatId;
  final UserEntity? recipient;
  const ChatEntity(
      {this.senderId,
      this.recipientId,
      this.senderName,
      this.recipientName,
      this.recentTextMessage,
      this.createdAt,
      this.senderProfile,
      this.recipientProfile,
      this.totalUnReadMessages,
      this.chatId,
      this.recipient});

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        senderName,
        recipientName,
        recentTextMessage,
        createdAt,
        senderProfile,
        recipientProfile,
        totalUnReadMessages,
        chatId,
        recipient
      ];
}
