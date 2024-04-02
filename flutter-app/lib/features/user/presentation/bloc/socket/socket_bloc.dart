import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/user/domain/usecase/disconnect_socket_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/init_socket_usecase.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final InitSocketUsecase _initSocketUsecase;
  final DisconnectSocketUsecase _disconnectSocketUsecase;
  SocketBloc(
      {required InitSocketUsecase initSocketUsecase,
      required DisconnectSocketUsecase disconnectSocketUsecase})
      : _initSocketUsecase = initSocketUsecase,
        _disconnectSocketUsecase = disconnectSocketUsecase,
        super(SocketDisonnected()) {
    on<ConnectSocketEvent>(_onConnectSocketEvent);
    on<DisconnectSocketEvent>(_onDisconnectSocketEvent);
  }
  void _onConnectSocketEvent(
      ConnectSocketEvent event, Emitter<SocketState> emit) {
    emit(SocketConnecting());
    final res = _initSocketUsecase(event.userId);
    res.fold((f) => emit(SocketConnectionFailed(f.message)),
        (s) => emit(SocketConnected()));
  }

  void _onDisconnectSocketEvent(
      DisconnectSocketEvent event, Emitter<SocketState> emit) {
    emit(SocketDisconnecting());
    final res = _disconnectSocketUsecase();
    res.fold((f) => emit(SocketConnectionFailed(f.message)),
        (s) => emit(SocketDisonnected()));
  }
}
