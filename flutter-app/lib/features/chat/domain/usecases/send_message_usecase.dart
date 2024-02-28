import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendMessageUseCase extends UsecaseWithParam<void, CustomSendMessgeParam> {
  final IChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  FutureVoid call(CustomSendMessgeParam param) async {
    return await repository.sendMessage(param.chatEntity, param.messageEntity);
  }
}

class CustomSendMessgeParam extends Equatable {
  final ChatEntity chatEntity;
  final MessageEntity messageEntity;
  const CustomSendMessgeParam(
      {required this.chatEntity, required this.messageEntity});

  @override
  List<Object?> get props => [chatEntity, messageEntity];
}
