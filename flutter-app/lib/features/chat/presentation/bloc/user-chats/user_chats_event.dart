part of 'user_chats_bloc.dart';

sealed class UserChatsEvent extends Equatable {
  const UserChatsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserChatsEvent extends UserChatsEvent {
  final String userId;
  final List<ChatModel> chats;
  const FetchUserChatsEvent({required this.userId, required this.chats});
  @override
  List<Object> get props => [userId, chats];
}

class FetchUpdatedUserChatsEvent extends UserChatsEvent {
  final String userId;
  final int totalUnreadMessages;
  final List<ChatModel> chats;

  const FetchUpdatedUserChatsEvent({
    required this.userId,
    required this.chats,
    required this.totalUnreadMessages,
  });
  @override
  List<Object> get props => [
        userId,
        chats,
        totalUnreadMessages,
      ];
}

class AddMessageUserChatsEvent extends UserChatsEvent {
  final String userId;
  final int totalUnreadMessages;
  final List<ChatModel> chats;
  final MessageModel message;
  final int? index;
  final bool isChatClosed;
  final ChatModel? chat;
  const AddMessageUserChatsEvent(
      {required this.userId,
      required this.chats,
      required this.totalUnreadMessages,
      required this.message,
      required this.chat,
      this.index,
      required this.isChatClosed});
  @override
  List<Object?> get props =>
      [userId, chats, totalUnreadMessages, message, index, isChatClosed, chat];
}

class IntiChatUserChatsEvent extends UserChatsEvent {
  final int totalUnreadMessages;
  final List<ChatModel> chats;
  final int? index;
  final String chatId;

  const IntiChatUserChatsEvent(
      {required this.chats,
      required this.totalUnreadMessages,
      required this.index,
      required this.chatId});
  @override
  List<Object> get props => [chats, totalUnreadMessages, chatId];
}
