import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMyChatsUseCase
    extends UsecaseWithParam<CustomGetMyChatsResponse, CustomGetMyChatsParams> {
  final IChatRepository repository;

  GetMyChatsUseCase({required this.repository});

  @override
  ResultFuture<CustomGetMyChatsResponse> call(CustomGetMyChatsParams param) {
    return repository.getMyChats(param.currentPage, param.userId);
  }
}

class CustomGetMyChatsParams extends Equatable {
  final int currentPage;
  final String userId;
  const CustomGetMyChatsParams(
      {required this.currentPage, required this.userId});

  @override
  List<Object?> get props => [currentPage, userId];
}

class CustomGetMyChatsResponse extends Equatable {
  final int totalUnreadMessages;
  final List<ChatModel> chats;
  const CustomGetMyChatsResponse(
      {required this.totalUnreadMessages, required this.chats});

  @override
  List<Object?> get props => [totalUnreadMessages, chats];
}
