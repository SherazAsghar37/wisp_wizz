// ignore: depend_on_referenced_packages
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_single_chat_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/init_chat_usecase.dart';

part 'user_chats_event.dart';
part 'user_chats_state.dart';

class UserChatsBloc extends Bloc<UserChatsEvent, UserChatsState> {
  final GetMyChatsUseCase _getMyChatsUseCase;
  final InitChatUsecase _initChatUsecase;
  final GetChatUsecase _getChatUsecase;
  int _currentPages = 0;

  UserChatsBloc(
      {required GetMyChatsUseCase getMyChatsUseCase,
      required InitChatUsecase initChatUsecase,
      required GetChatUsecase getChatUsecase})
      : _getMyChatsUseCase = getMyChatsUseCase,
        _initChatUsecase = initChatUsecase,
        _getChatUsecase = getChatUsecase,
        super(UserChatsInitial()) {
    on<FetchUserChatsEvent>(_onFetchUserChatsEvent);
    on<FetchUpdatedUserChatsEvent>(_onFetchUpdatedUserChatsEvent);
    on<AddMessageUserChatsEvent>(_onAddMessageUserChatsEvent);
    on<IntiChatUserChatsEvent>(_onIntiChatUserChatsEvent);
  }

  Future<void> _onFetchUserChatsEvent(
      FetchUserChatsEvent event, Emitter<UserChatsState> emit) async {
    DebugHelper.printWarning("here1");
    emit(UsersChatsFetching(event.chats, 0));
    DebugHelper.printWarning("here2");
    final res = await _getMyChatsUseCase(CustomGetMyChatsParams(
        currentPage: _currentPages, userId: event.userId));
    res.fold((f) => emit(UsersChatsFetchFailed(f.message)), (s) {
      DebugHelper.printWarning(s.toString());
      emit(UsersChatsFetched(
          [...event.chats, ...s.chats], s.totalUnreadMessages));
    });
  }

  Future<void> _onFetchUpdatedUserChatsEvent(
      FetchUpdatedUserChatsEvent event, Emitter<UserChatsState> emit) async {
    emit(UsersChatsFetching(event.chats, event.totalUnreadMessages));
    final res = await _getMyChatsUseCase(
        CustomGetMyChatsParams(currentPage: 0, userId: event.userId));
    res.fold(
        (f) => emit(UsersChatsFetchFailed(
              f.message,
            )), (s) {
      emit(UsersChatsFetched(s.chats, s.totalUnreadMessages));
    });
  }

  Future<void> _onAddMessageUserChatsEvent(
      AddMessageUserChatsEvent event, Emitter<UserChatsState> emit) async {
    print("here");
    emit(UsersChatsFetching(
      event.chats,
      event.totalUnreadMessages,
    ));
    int? index = event.index;
    if (!event.isChatClosed) {
      print("chat opened");

      if (index == null) {
        index = event.chats
            .indexWhere((element) => element.chatId == event.message.chatId);
        if (index == -1) {
          event.chat!.messages.add(event.message);
          return emit(UsersChatsFetched(
            [event.chat!, ...event.chats],
            event.totalUnreadMessages,
          ));
        }
      }

      event.chats[index].messages.add(event.message);
      final chatModel = event.chats.removeAt(index);
      emit(UsersChatsFetched(
        [chatModel, ...event.chats],
        event.totalUnreadMessages,
      ));
    } else {
      int index = event.chats
          .indexWhere((element) => element.chatId == event.message.chatId);
      log(index.toString());
      if (index == -1) {
        final res = await _getChatUsecase(CustomGetChatParam(
            recipientId: event.recipientId, senderId: event.userId));
        res.fold((f) => emit(UsersChatsFetchFailed(f.message)), (s) {
          s.messages.add(event.message);
          s = s.copyWith(unreadMessages: s.unreadMessages + 1);
          emit(UsersChatsFetched(
            [s, ...event.chats],
            event.totalUnreadMessages + 1,
          ));
        });
      } else {
        event.chats[index].messages.add(event.message);
        event.chats[index] = event.chats[index]
            .copyWith(unreadMessages: event.chats[index].unreadMessages + 1);
        emit(UsersChatsFetched(
          event.chats,
          event.totalUnreadMessages + 1,
        ));
      }
    }
  }

  Future<void> _onIntiChatUserChatsEvent(
      IntiChatUserChatsEvent event, Emitter<UserChatsState> emit) async {
    emit(UsersChatsFetching(
      event.chats,
      event.totalUnreadMessages,
    ));
    final index = event.index ??
        event.chats.indexWhere((element) => element.chatId == event.chatId);
    if (index != -1) {
      final res = _initChatUsecase(event.chats[index].chatId);
      res.fold((f) => emit(UsersChatsFetchFailed(f.message)), (s) {
        final unreads = event.chats[index].unreadMessages;
        event.chats[index] = event.chats[index].copyWith(unreadMessages: 0);

        emit(UsersChatsFetched(
          event.chats,
          event.totalUnreadMessages - unreads,
        ));
      });
      return;
    } else {
      emit(UsersChatsFetched(
        event.chats,
        event.totalUnreadMessages,
      ));
    }
  }
}
