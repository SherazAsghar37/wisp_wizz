part of 'current_chat_bloc.dart';

sealed class CurrentChatEvent extends Equatable {
  const CurrentChatEvent();

  @override
  List<Object?> get props => [];
}

class CurrentChatOpenEvent extends CurrentChatEvent {
  final String chatId;
  final String userId;
  final int? index;
  const CurrentChatOpenEvent(
      {required this.chatId, required this.userId, required this.index});
  @override
  List<Object?> get props => [chatId, userId, index];
}

class CurrentChatCloseEvent extends CurrentChatEvent {
  final String userId;
  const CurrentChatCloseEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}
