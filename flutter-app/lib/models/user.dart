import 'dart:convert';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final int phoneNumber;
  final String countryCode;
  final String id;
  final bool status;
  final DateTime lastSeen;
  final String profileUrl;

  const User({
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.id,
    required this.status,
    required this.lastSeen,
    required this.profileUrl,
  });

  User copyWith({
    String? name,
    int? phoneNumber,
    String? countryCode,
    String? id,
    bool? status,
    DateTime? lastSeen,
    String? profileUrl,
  }) {
    return User(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      id: id ?? this.id,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'id': id,
      'status': status,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'profileUrl': profileUrl,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : this(
          name: map['name'] as String,
          phoneNumber: map['phoneNumber'] as int,
          countryCode: map['countryCode'],
          id: map['id'] as String,
          status: map['status'] as bool,
          lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
          profileUrl: map['profileUrl'] as String,
        );

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, phoneNumber: $phoneNumber, countryCode: $countryCode, id: $id, status: $status, lastSeen: $lastSeen, profileUrl: $profileUrl)';
  }

  @override
  List<Object?> get props =>
      [name, id, phoneNumber, countryCode, status, lastSeen, profileUrl];
}
