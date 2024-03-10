part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatFetching extends ChatState {
  final int index;
  const ChatFetching({required this.index});

  @override
  List<Object> get props => [index];
}

final class ChatFetched extends ChatState {
  final ChatModel chat;
  const ChatFetched({
    required this.chat,
  });
  @override
  List<Object> get props => [chat];
}

final class ChatFetchFailed extends ChatState {
  final String message;
  const ChatFetchFailed({required this.message});
  @override
  List<Object> get props => [message];
}
