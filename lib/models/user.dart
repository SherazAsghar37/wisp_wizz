// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/core/utils/app_enums.dart';

class User extends Equatable {
  final String name;
  final int phoneNumber;
  final CountryCodes countryCode;
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
    CountryCodes? countryCode,
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
      'countryCode': _encodeCountryCode(countryCode),
      'id': id,
      'status': status,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'profileUrl': profileUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as int,
      countryCode: _decodeCountryCode(map['countryCode']),
      id: map['id'] as String,
      status: map['status'] as bool,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
      profileUrl: map['profileUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, phoneNumber: $phoneNumber, countryCode: $countryCode, id: $id, status: $status, lastSeen: $lastSeen, profileUrl: $profileUrl)';
  }

  static CountryCodes _decodeCountryCode(String code) {
    switch (code) {
      case "+92":
        return CountryCodes.PK;
      default:
        return CountryCodes.PK;
    }
  }

  static String _encodeCountryCode(CountryCodes code) {
    switch (code) {
      case CountryCodes.PK:
        return "+92";
      default:
        return "+92";
    }
  }

  @override
  List<Object?> get props =>
      [name, id, phoneNumber, countryCode, status, lastSeen, profileUrl];
}
