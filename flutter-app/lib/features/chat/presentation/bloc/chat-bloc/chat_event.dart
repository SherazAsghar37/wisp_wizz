part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatFetchEvent extends ChatEvent {
  final String recipientId;
  final String senderId;
  final int index;
  const ChatFetchEvent(
      {required this.recipientId, required this.senderId, required this.index});
  @override
  List<Object> get props => [recipientId, senderId, index];
}

// class ChatUpdateEvent extends ChatEvent {
//   final String recipientId;
//   final String senderId;
//   final int index;
//   const ChatUpdateEvent(
//       {required this.recipientId, required this.senderId, required this.index});
//   @override
//   List<Object> get props => [recipientId, senderId, index];
// }
