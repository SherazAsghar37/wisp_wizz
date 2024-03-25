import 'package:equatable/equatable.dart';

enum ReceiptStatus { sent, deliverred, read }

extension EnumParsing on ReceiptStatus {
  String value() {
    return toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class ReceiptEntity extends Equatable {
  final String? recipientId;
  final String? messageId;
  final ReceiptStatus? status;
  final DateTime? createdAt;
  final String? receiptId;

  const ReceiptEntity(
      {this.recipientId,
      this.messageId,
      this.status,
      this.createdAt,
      this.receiptId});

  @override
  List<Object?> get props =>
      [recipientId, messageId, status, createdAt, receiptId];
}
