import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMyChatUseCase extends UsecaseWithParamSync<StreamList, ChatEntity> {
  final IChatRepository repository;

  GetMyChatUseCase({required this.repository});

  @override
  ResultStreamList<ChatEntity> call(ChatEntity param) {
    return repository.getMyChat(param);
  }
}
