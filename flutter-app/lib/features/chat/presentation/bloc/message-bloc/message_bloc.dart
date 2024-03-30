import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/chat/data/models/message_model.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/received_message_usecase.dart';
import 'package:wisp_wizz/features/chat/domain/usecases/send_message_usecase.dart';
import 'dart:async';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendMessageUseCase _sendMessageUseCase;
  final ReceivedMessageUseCase _receivedMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();

  Stream<List<MessageModel>> get messagesStream => _messageController.stream;

  // final _insertMessageController = StreamController<MessageModel>.broadcast();
  // StreamSink<MessageModel> get inInsertMessage => _insertMessageController.sink;
  // Stream<MessageModel> get outInsertMessage => _insertMessageController.stream;

  MessageBloc(
      {required SendMessageUseCase sendMessageUseCase,
      required ReceivedMessageUseCase receivedMessageUseCase,
      required GetMessagesUseCase getMessagesUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        _receivedMessageUseCase = receivedMessageUseCase,
        _getMessagesUseCase = getMessagesUseCase,
        super(MessageInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ReceivedMessageEvent>(_onReceivedMessageEvent);
    on<FetchMessagesEvent>(_onfetchMessages);
    // on<InitMessagesEvent>(_onInitMessagesEvent);
  }
  void _onSendMessage(
      SendMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageSending());

    final response = await _sendMessageUseCase(CustomSendMessgeParam(
      message: event.message,
      senderId: event.senderId,
      chatId: event.chatId,
      recipientId: event.recipientId,
    ));
    response.fold((f) => emit(MessageFailed(f.message)), (s) {
      _addToSink(s);
      emit(MessageSent(message: s));
    });
  }

  void _onReceivedMessageEvent(
      ReceivedMessageEvent event, Emitter<MessageState> emit) async {
    emit(MessageReceiving());
    final response = await _receivedMessageUseCase(CustomReceivedMessgeParam(
      message: event.message,
      senderId: event.senderId,
      chatId: event.chatId,
      recipientId: event.recipientId,
      messageId: event.messageId,
      repliedToId: event.repliedToId,
      repliedToMessage: event.repliedMessage,
      isChatClosed: event.isChatClosed,
    ));
    response.fold((f) => emit(MessageFailed(f.message)), (s) {
      _addToSink(s);
      print(event.isChatClosed.toString());
      emit(MessageReceived(
          message: s, isChatClosed: event.isChatClosed, index: event.index));
    });
  }

  Future<void> _onfetchMessages(
      FetchMessagesEvent event, Emitter<MessageState> emit) async {
    emit(MessagesFetching());
    final response = await _getMessagesUseCase(event.chatId);
    response.fold((f) => emit(MessagesFetchFailed(f.message)), (s) {
      if (s.isNotEmpty) {
        _messageController.sink.add(s);
      }
      emit(const MessagesFetched());
    });
  }

  // void _onInitMessagesEvent(
  //     InitMessagesEvent event, Emitter<MessageState> emit) {
  //   emit(MessagesState(messages: event.messages));
  // }

  void dispose() {
    _messageController.close();
  }

  void _addToSink(MessageModel data) {
    _messageController.sink.add([data]);
  }
}
