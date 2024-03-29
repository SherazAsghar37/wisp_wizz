import 'package:equatable/equatable.dart';

abstract class UserEntity extends Equatable {
  final String? _id;
  final String? name;
  final String? phoneNumber;
  final bool? status;
  final DateTime? lastSeen;
  final String image;

  const UserEntity({
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
