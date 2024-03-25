part of 'current_chat_bloc.dart';

sealed class CurrentChatEvent extends Equatable {
  const CurrentChatEvent();

  @override
  List<Object> get props => [];
}

class CurrentChatOpenEvent extends CurrentChatEvent {
  final String chatId;
  final String userId;
  const CurrentChatOpenEvent({required this.chatId, required this.userId});
  @override
  List<Object> get props => [chatId, userId];
}

class CurrentChatCloseEvent extends CurrentChatEvent {
  final String userId;
  const CurrentChatCloseEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}
