import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendMessageUseCase
    extends UsecaseWithParam<void, CustomGetSingleChatPAram> {
  final IChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  ResultFuture<String> call(CustomGetSingleChatPAram param) {
    return repository.getSingleChat(
      recipientId: param.recipientId,
      senderId: param.senderId,
    );
  }
}

class CustomGetSingleChatPAram extends Equatable {
  final String senderId;
  final String recipientId;
  const CustomGetSingleChatPAram({
    required this.senderId,
    required this.recipientId,
  });

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
      ];
}
