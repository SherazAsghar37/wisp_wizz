import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/chat_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetChatUsecase extends UsecaseWithParam<void, CustomGetChatParam> {
  final IChatRepository repository;

  GetChatUsecase({required this.repository});

  @override
  ResultFuture<ChatModel> call(CustomGetChatParam param) {
    return repository.getSingleChat(
      recipientId: param.recipientId,
      senderId: param.senderId,
    );
  }
}

class CustomGetChatParam extends Equatable {
  final String senderId;
  final String recipientId;
  const CustomGetChatParam({
    required this.senderId,
    required this.recipientId,
  });

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
      ];
}
