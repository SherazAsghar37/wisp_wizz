// ignore_for_file: unused_field

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/shared/entities/user_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';

class ChatEntity extends Equatable {
  final String? senderId;
  final String? recentTextMessage;
  final DateTime? createdAt;
  final int? unreadMessages;
  final String? chatId;
  final UserEntity? recipient;
  // final MessageEntity? lastMessage;
  final List<MessageEntity>? messages;
  const ChatEntity(
      {this.senderId,
      this.recentTextMessage,
      this.createdAt,
      this.unreadMessages,
      this.chatId,
      this.recipient,
      this.messages
      });

  @override
  List<Object?> get props => [
        senderId,
        recentTextMessage,
        createdAt,
        unreadMessages,
        chatId,
        recipient,
        messages
      ];
}
