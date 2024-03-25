import 'package:equatable/equatable.dart';

enum Typing { start, stop }

extension TypingParser on Typing {
  String value() {
    return toString().split('.').last;
  }

  static Typing fromString(String? event) {
    return Typing.values.firstWhere((element) => element.value() == event);
  }
}

class TypingEventEntity extends Equatable {
  final String? from;
  final String? to;
  final Typing? event;
  final String? typingEventId;
  final String? chatId;
  const TypingEventEntity(
      {this.chatId, this.from, this.to, this.event, this.typingEventId});

  @override
  List<Object?> get props => [from, to, event, typingEventId, chatId];
}
