import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMyChatUseCase extends UsecaseWithParamSync<StreamList, String> {
  final IChatRepository repository;

  GetMyChatUseCase({required this.repository});

  @override
  ResultStreamList<ChatEntity> call(String param) {
    return repository.getMyChats(param);
  }
}
