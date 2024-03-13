import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/send_message_usecase.dart';
import 'dart:async';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();

  Stream<List<MessageModel>> get messagesStream => _messageController.stream;

  // final _insertMessageController = StreamController<MessageModel>.broadcast();
  // StreamSink<MessageModel> get inInsertMessage => _insertMessageController.sink;
  // Stream<MessageModel> get outInsertMessage => _insertMessageController.stream;

  MessageBloc(
      {required SendMessageUseCase sendMessageUseCase,
      required GetMessagesUseCase getMessagesUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _getMessagesUseCase = getMessagesUseCase,
        super(MessageInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<FetchMessagesEvent>(_onfetchMessages);
  }
  void _onSendMessage(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageSending());
    final response = await _sendMessageUseCase(CustomSendMessgeParam(
        message: event.message,
        senderId: event.senderId,
        chatId: event.chatId,
        recipientId: event.recipientId));
    response.fold((f) => emit(MessageFailed(f.message)), (s) {
      _messageController.sink.add([s]);
      emit(MessageSent());
    });
  }

  Future<void> _onfetchMessages(
      FetchMessagesEvent event, Emitter<MessageState> emit) async {
    emit(MessagesFetching());
    final response = await _getMessagesUseCase(event.chatId);
    response.fold((f) => emit(MessagesFetchFailed(f.message)), (s) {
      _messageController.sink.add(s);
      emit(const MessagesFetched());
    });
  }

  void dispose() {
    _messageController.close();
  }
}
