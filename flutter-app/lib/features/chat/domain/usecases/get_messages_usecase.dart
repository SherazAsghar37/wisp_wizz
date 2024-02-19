import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/message_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMessagesUseCase
    extends UsecaseWithParamSync<StreamList, MessageEntity> {
  final IChatRepository repository;

  GetMessagesUseCase({required this.repository});

  @override
  ResultStreamList<MessageEntity> call(MessageEntity param) {
    return repository.getMessages(param);
  }
}
