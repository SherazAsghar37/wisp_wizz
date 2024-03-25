import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendStatusUsecase
    extends UsecaseWithParamSync<void, CustomSendStatusParam> {
  final IChatRepository repository;

  SendStatusUsecase({required this.repository});

  @override
  Result<void> call(CustomSendStatusParam param) {
    return repository.sendChatStatus(
        chatId: param.chatId, userId: param.userId);
  }
}

class CustomSendStatusParam extends Equatable {
  final String? chatId;
  final String userId;
  const CustomSendStatusParam({required this.chatId, required this.userId});

  @override
  List<Object?> get props => [
        chatId,
        userId,
      ];
}
