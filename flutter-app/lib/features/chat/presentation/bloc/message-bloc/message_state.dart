part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageSending extends MessageState {}

final class MessageSent extends MessageState {}

final class MessageFailed extends MessageState {
  final String message;
  const MessageFailed(this.message);

  @override
  List<Object> get props => [message];
}
