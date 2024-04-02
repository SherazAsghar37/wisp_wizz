part of 'socket_bloc.dart';

sealed class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object> get props => [];
}

// final class SocketInitial extends SocketState {}

final class SocketConnecting extends SocketState {}

final class SocketDisconnecting extends SocketState {}

final class SocketConnected extends SocketState {}

final class SocketDisonnected extends SocketState {}

final class SocketConnectionFailed extends SocketState {
  final String message;
  const SocketConnectionFailed(this.message);

  @override
  List<Object> get props => [message];
}
