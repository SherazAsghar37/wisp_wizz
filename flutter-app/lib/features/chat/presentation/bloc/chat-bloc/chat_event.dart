part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatFetch extends ChatEvent {
  final String recipientId;
  final String senderId;
  const ChatFetch({required this.recipientId, required this.senderId});
  @override
  List<Object> get props => [recipientId, senderId];
}
