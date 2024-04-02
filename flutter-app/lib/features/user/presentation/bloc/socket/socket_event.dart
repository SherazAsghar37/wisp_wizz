part of 'socket_bloc.dart';

sealed class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectSocketEvent extends SocketEvent {
  final String userId;
  const ConnectSocketEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class DisconnectSocketEvent extends SocketEvent {
  const DisconnectSocketEvent();
}