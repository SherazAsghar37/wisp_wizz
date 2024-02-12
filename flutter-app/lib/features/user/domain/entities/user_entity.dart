import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class UserEnitity extends Equatable {
  final String? _id;
  final String? name;
  final String? phoneNumber;
  final bool? status;
  final DateTime? lastSeen;
  final Uint8List image;

  const UserEnitity({
    required this.name,
    required this.phoneNumber,
    required String id,
    required this.status,
    required this.lastSeen,
    required this.image,
  }) : _id = id;

  @override
  List<Object?> get props => [name, _id, phoneNumber, status, lastSeen, image];
}
