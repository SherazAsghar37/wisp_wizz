// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/send_message_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendMessageUseCase _sendMessageUseCase;

  MessageBloc({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        super(MessageInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }
  void _onSendMessage(SendMessageEvent event, Emitter<MessageState> emit) {
    emit(MessageSending());
    final response = _sendMessageUseCase(CustomSendMessgeParam(
        message: event.message,
        senderId: event.senderId,
        chatId: event.chatId,
        recipientId: event.recipientId));
    response.fold(
        (l) => emit(MessageFailed(l.message)), (r) => emit(MessageSent()));
  }
}
