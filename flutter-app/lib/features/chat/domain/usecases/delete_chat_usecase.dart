import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/entities/chat_entity.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class DeleteMyChatUseCase extends UsecaseWithParam<void, ChatEntity> {
  final IChatRepository repository;

  DeleteMyChatUseCase({required this.repository});

  @override
  FutureVoid call(ChatEntity param) async {
    return await repository.deleteChat(param);
  }
}
