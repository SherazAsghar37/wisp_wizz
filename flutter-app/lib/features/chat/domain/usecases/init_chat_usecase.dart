import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class InitChatUsecase extends UsecaseWithParamSync<void, String> {
  final IChatRepository repository;

  InitChatUsecase({required this.repository});

  @override
  Result<void> call(String param) {
    return repository.initChat(
      chatId: param,
    );
  }
}
