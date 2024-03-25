// ignore_for_file: must_be_immutable, overridden_fields

import 'package:wisp_wizz/features/chat/domain/entities/recipient_entity.dart';

class Receipt extends ReceiptEntity {
  @override
  final String recipientId;
  @override
  final String messageId;
  @override
  final ReceiptStatus status;
  @override
  final DateTime createdAt;
  @override
  final String receiptId;

  const Receipt(
      {required this.recipientId,
      required this.messageId,
      required this.status,
      required this.createdAt,
      required this.receiptId});

  Map<String, dynamic> toJson() => {
        'recipientId': recipientId,
        'messageId': messageId,
        'status': status.value(),
        'createdAt': createdAt,
        "receiptId": receiptId
      };

  Receipt.fromJson(Map<String, dynamic> json)
      : this(
            recipientId: json['recipientId'],
            messageId: json['messageId'],
            status: EnumParsing.fromString(json['status']),
            createdAt: json['createdAt'],
            receiptId: json['receiptId']);
}
