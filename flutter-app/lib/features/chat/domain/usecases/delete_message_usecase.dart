import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class DeleteMessageUseCase extends UsecaseWithParam<void, MessageEntity> {
  final IChatRepository repository;

  DeleteMessageUseCase({required this.repository});

  @override
  FutureVoid call(MessageEntity param) async {
    return await repository.deleteMessage(param);
  }
}
