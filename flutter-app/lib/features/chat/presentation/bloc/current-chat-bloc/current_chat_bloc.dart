import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/send_status_usecase.dart';

part 'current_chat_event.dart';
part 'current_chat_state.dart';

class CurrentChatBloc extends Bloc<CurrentChatEvent, CurrentChatState> {
  final SendStatusUsecase _sendStatusUsecase;
  CurrentChatBloc({required SendStatusUsecase sendStatusUsecase})
      : _sendStatusUsecase = sendStatusUsecase,
        super(CurrentChatInitial()) {
    on<CurrentChatOpenEvent>(_onCurrentChatOpenEvent);
    on<CurrentChatCloseEvent>(_onCurrentChatCloseEvent);
  }
  void _onCurrentChatOpenEvent(
      CurrentChatOpenEvent event, Emitter<CurrentChatState> emit) {
    // emit(CurrentChatOpening());
    final res = _sendStatusUsecase(
        CustomSendStatusParam(chatId: event.chatId, userId: event.userId));
    res.fold((f) => emit(CurrentChatStatusFailed(message: f.message)),
        (s) => emit(CurrentChatOpened(chatId: event.chatId)));
  }

  void _onCurrentChatCloseEvent(
      CurrentChatCloseEvent event, Emitter<CurrentChatState> emit) {
    final res = _sendStatusUsecase(
        CustomSendStatusParam(chatId: null, userId: event.userId));
    res.fold((f) => emit(CurrentChatStatusFailed(message: f.message)),
        (s) => emit(const CurrentChatClosed()));
  }
}
