// ignore_for_file: must_be_immutable, overridden_fields

import 'package:wisp_wizz/features/chat/domain/entities/typing_event_entity.dart';

class TypingEvent extends TypingEventEntity {
  @override
  final String from;
  @override
  final String to;
  @override
  final Typing event;
  @override
  final String typingEventId;
  @override
  final String chatId;
  const TypingEvent(
      {required this.chatId,
      required this.from,
      required this.to,
      required this.event,
      required this.typingEventId});

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'from': from,
        'to': to,
        'event': event.value(),
        "typingEventId": typingEventId
      };

  TypingEvent.fromJson(Map<String, dynamic> json)
      : this(
            chatId: json['chatId'],
            from: json['from'],
            to: json['to'],
            event: TypingParser.fromString(json['event']),
            typingEventId: json["typingEventId"]);
}
