part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class Chat extends ChatState {
  final List<MessageModel> messages;
  final ChatModel chat;
  const Chat({required this.chat, required this.messages});
  @override
  List<Object> get props => [messages, chat];
}
