part of 'user_chats_bloc.dart';

sealed class UserChatsEvent extends Equatable {
  const UserChatsEvent();

  @override
  List<Object> get props => [];
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
  final List<ChatModel> chats;
  const FetchUpdatedUserChatsEvent({required this.userId, required this.chats});
  @override
  List<Object> get props => [userId, chats];
}
