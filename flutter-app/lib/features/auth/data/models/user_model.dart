import 'dart:convert';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final int phoneNumber;
  final String countryCode;
  final String id;
  final bool status;
  final DateTime lastSeen;
  final String? image;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
    required this.id,
    required this.status,
    required this.lastSeen,
    this.image,
  });

  UserModel copyWith({
    String? name,
    int? phoneNumber,
    String? countryCode,
    String? id,
    bool? status,
    DateTime? lastSeen,
    String? image,
  }) {
    return UserModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
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
      'countryCode': countryCode,
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
          countryCode: map['countryCode'],
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
    return 'UserModel(name: $name, phoneNumber: $phoneNumber, countryCode: $countryCode, id: $id, status: $status, lastSeen: $lastSeen, image: $image)';
  }

  UserModel.empty()
      : this(
            countryCode: "+92",
            id: "0",
            lastSeen: DateTime.now(),
            name: "empty.name",
            phoneNumber: 0000000000,
            image: null,
            status: false);

  @override
  List<Object?> get props =>
      [name, id, phoneNumber, countryCode, status, lastSeen, image];
}
