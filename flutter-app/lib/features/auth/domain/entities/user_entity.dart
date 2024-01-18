import 'package:equatable/equatable.dart';

class UserEnitity extends Equatable {
  final String id;
  final String name;
  final int phoneNumber;
  final String countryCode;
  final bool status;
  final DateTime lastSeen;
  final String profileUrl;

  const UserEnitity({
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.id,
    required this.status,
    required this.lastSeen,
    required this.profileUrl,
  });

  @override
  List<Object?> get props =>
      [name, id, phoneNumber, countryCode, status, lastSeen, profileUrl];
}
