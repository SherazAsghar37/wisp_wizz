// ignore_for_file: overridden_fields

import 'dart:convert';
import 'package:wisp_wizz/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEnitity {
  @override
  final String name;
  @override
  final String phoneNumber;
  final String id;
  @override
  final bool status;
  @override
  final DateTime lastSeen;
  @override
  final String? image;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.id,
    required this.status,
    required this.lastSeen,
    this.image,
  }) : super(
            name: name,
            phoneNumber: phoneNumber,
            id: id,
            status: status,
            lastSeen: lastSeen,
            image: image);

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? countryCode,
    String? id,
    bool? status,
    DateTime? lastSeen,
    String? image,
  }) {
    return UserModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      '_id': id,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'image': image,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : this(
          name: map['name'],
          phoneNumber: map['phoneNumber'],
          id: map['_id'],
          status: map['status'],
          lastSeen: DateTime.parse(map['lastSeen']),
          image: map['image'],
        );

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, phoneNumber: $phoneNumber,  id: $id, status: $status, lastSeen: $lastSeen, image: $image)';
  }

  UserModel.empty()
      : this(
            id: "0",
            lastSeen: DateTime.now(),
            name: "empty.name",
            phoneNumber: "+920000000000",
            image: null,
            status: false);

  @override
  List<Object?> get props => [name, id, phoneNumber, status, lastSeen, image];
}
