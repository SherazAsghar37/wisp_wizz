import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/repositories/i_chat_repository.dart';

class UpdateMessageUseCase extends UsecaseWithParam<void, MessageModel> {
  final IChatRepository repository;

  UpdateMessageUseCase({required this.repository});

  @override
  FutureVoid call(MessageModel param) async {
    return await repository.updateMessage(param);
  }
}
