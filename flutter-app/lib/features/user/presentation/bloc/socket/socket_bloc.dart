import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/user/domain/usecase/init_socket_usecase.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final InitSocketUsecase _initSocketUsecase;
  SocketBloc({required InitSocketUsecase initSocketUsecase})
      : _initSocketUsecase = initSocketUsecase,
        super(SocketDisonnected()) {
    on<ConnectSocketEvent>(_onConnectSocketEvent);
  }
  void _onConnectSocketEvent(
      ConnectSocketEvent event, Emitter<SocketState> emit) {
    emit(SocketConnecting());
    final res = _initSocketUsecase(event.userId);
    res.fold((f) => emit(SocketConnectionFailed(f.message)),
        (s) => emit(SocketConnected()));
  }
}
