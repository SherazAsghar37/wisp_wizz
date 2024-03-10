import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMyChatsUseCase extends UsecaseWithParamSync<StreamList, String> {
  final IChatRepository repository;

  GetMyChatsUseCase({required this.repository});

  @override
  ResultStreamList<ChatEntity> call(String param) {
    return repository.getMyChats(param);
  }
}
