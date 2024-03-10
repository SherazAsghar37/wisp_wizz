// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_single_chat_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChatsUseCase _getMyChatUseCase;
  final GetChatUsecase _getChatUsecase;

  ChatBloc(
      {required GetMyChatsUseCase getMyChatUseCase,
      required GetChatUsecase getChatUsecase})
      : _getMyChatUseCase = getMyChatUseCase,
        _getChatUsecase = getChatUsecase,
        super(ChatInitial()) {
    on<ChatFetchEvent>(_onFetchChat);
  }
  Future<void> _onFetchChat(
      ChatFetchEvent event, Emitter<ChatState> emit) async {
    emit(ChatFetching(index: event.index));
    final res = await _getChatUsecase(CustomGetChatParam(
        senderId: event.senderId, recipientId: event.recipientId));
    res.fold((f) => emit(ChatFetchFailed(message: f.message)),
        (s) => emit(ChatFetched(chat: s)));
  }
}
