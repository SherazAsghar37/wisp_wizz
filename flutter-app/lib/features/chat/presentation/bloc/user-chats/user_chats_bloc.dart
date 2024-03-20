// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';

part 'user_chats_event.dart';
part 'user_chats_state.dart';

class UserChatsBloc extends Bloc<UserChatsEvent, UserChatsState> {
  final GetMyChatsUseCase _getMyChatsUseCase;
  int _currentPages = 0;

  UserChatsBloc({required GetMyChatsUseCase getMyChatsUseCase})
      : _getMyChatsUseCase = getMyChatsUseCase,
        super(UserChatsInitial()) {
    on<FetchUserChatsEvent>(_onFetchUserChatsEvent);
    on<FetchUpdatedUserChatsEvent>(_onFetchUpdatedUserChatsEvent);
  }

  Future<void> _onFetchUserChatsEvent(
      FetchUserChatsEvent event, Emitter<UserChatsState> emit) async {
    emit(UsersChatsFetching(event.chats));
    final res = await _getMyChatsUseCase(CustomGetMyChatsParams(
        currentPage: _currentPages, userId: event.userId));
    res.fold((f) => emit(UsersChatsFetchFailed(f.message)), (s) {
      _currentPages += 1;
      emit(UsersChatsFetched([...event.chats, ...s]));
    });
  }

  Future<void> _onFetchUpdatedUserChatsEvent(
      FetchUpdatedUserChatsEvent event, Emitter<UserChatsState> emit) async {
    emit(UsersChatsFetching(event.chats));
    final res = await _getMyChatsUseCase(
        CustomGetMyChatsParams(currentPage: 0, userId: event.userId));
    res.fold((f) => emit(UsersChatsFetchFailed(f.message)), (s) {
      emit(UsersChatsFetched(s));
    });
  }
}
