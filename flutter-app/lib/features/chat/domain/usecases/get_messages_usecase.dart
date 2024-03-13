import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class GetMessagesUseCase extends UsecaseWithParam<List<MessageModel>, String> {
  final IChatRepository repository;

  GetMessagesUseCase({required this.repository});

  @override
  ResultFuture<List<MessageModel>> call(String param) {
    return repository.getMessages(param);
  }
}
