part of 'current_chat_bloc.dart';

sealed class CurrentChatState extends Equatable {
  const CurrentChatState();

  @override
  List<Object> get props => [];
}

final class CurrentChatInitial extends CurrentChatState {}

final class CurrentChatOpening extends CurrentChatState {}

final class CurrentChatClosing extends CurrentChatState {}

final class CurrentChatOpened extends CurrentChatState {
  final String chatId;
  final int index;
  const CurrentChatOpened({required this.chatId, required this.index});
  @override
  List<Object> get props => [chatId, index];
}

final class CurrentChatClosed extends CurrentChatState {
  const CurrentChatClosed();
  @override
  List<Object> get props => [];
}

final class CurrentChatStatusFailed extends CurrentChatState {
  final String message;
  const CurrentChatStatusFailed({required this.message});
  @override
  List<Object> get props => [message];
}
