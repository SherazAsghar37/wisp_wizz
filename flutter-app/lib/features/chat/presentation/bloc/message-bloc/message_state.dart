part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageSending extends MessageState {}

final class MessageReceiving extends MessageState {}

final class MessageSent extends MessageState {}

final class MessageReceived extends MessageState {
  final MessageModel message;
  const MessageReceived({required this.message});

  @override
  List<Object> get props => [message];
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
