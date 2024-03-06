// ignore_for_file: unused_field

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/shared/entities/user_entity.dart';

class ChatEntity extends Equatable {
  final UserEntity? sender;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final int? totalUnReadMessages;
  final String? chatId;
  final UserEntity? recipient;
  const ChatEntity(
      {this.sender,
      this.recentTextMessage,
      this.createdAt,
      this.totalUnReadMessages,
      this.chatId,
      this.recipient});

  @override
  List<Object?> get props => [
        sender,
        recentTextMessage,
        createdAt,
        totalUnReadMessages,
        chatId,
        recipient
      ];
}
