import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class SendMessageUseCase extends UsecaseWithParamSync<void, MessageModel> {
  final IChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  ResultVoid call(MessageModel param) {
    return repository.sendMessage(param);
  }
}

// class CustomSendMessgeParam extends Equatable {
//   final ChatEntity chatEntity;
//   final MessageEntity messageEntity;
//   const CustomSendMessgeParam(
//       {required this.chatEntity, required this.messageEntity});

//   @override
//   List<Object?> get props => [chatEntity, messageEntity];
// }
