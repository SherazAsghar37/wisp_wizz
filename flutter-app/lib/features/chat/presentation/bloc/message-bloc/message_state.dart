part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageSending extends MessageState {}

final class MessageReceiving extends MessageState {}

final class MessageSent extends MessageState {
  final MessageModel message;
  const MessageSent({required this.message});

  @override
  List<Object> get props => [message];
  // final List<MessageModel> messages;
  // const MessageSent({required this.messages});
  // @override
  // List<Object> get props => [
  //       messages,
  //     ];
}

final class MessageReceived extends MessageState {
  final MessageModel message;
  final bool isChatClosed;
  final int index;
  const MessageReceived(
      {required this.message, required this.isChatClosed, required this.index});

  @override
  List<Object> get props => [message, isChatClosed, index];
}

final class MessageFailed extends MessageState {
  final String message;
  const MessageFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class MessagesFetching extends MessageState {}

final class MessagesFetched extends MessageState {
  const MessagesFetched();

  // @override
  // List<Object> get props => [
  //       _messageController,
  //       inMessage,
  //       outMessage,
  //       _insertMessageController,
  //       inInsertMessage
  //     ];
}

final class MessagesFetchFailed extends MessageState {
  final String message;
  const MessagesFetchFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class MessagesState extends MessageState {
  final List<MessageModel> messages;
  const MessagesState({required this.messages});
  @override
  List<Object> get props => [
        messages,
      ];
}
