// ignore_for_file: overridden_fields
import 'dart:convert';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/contacts/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  // ignore: unused_field
  final String _id;
  @override
  final String phoneNumber;
  @override
  final String name;
  @override
  final String image;
  const ContactModel(
      {required String id,
      required this.phoneNumber,
      required this.image,
      required this.name})
      : _id = id,
        super(id: id, phoneNumber: phoneNumber, image: image, name: name);
  String get id => _id;

  ContactModel copyWith({
    String? phoneNumber,
    String? name,
    String? id,
    String? image,
  }) {
    return ContactModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      id: id ?? _id,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'name': name,
      'id': _id,
      'image': image,
    };
  }

  ContactModel.fromMap(Map<String, dynamic> map)
      : this(
          phoneNumber: map['phoneNumber'],
          name: map['name'],
          id: map['id'],
          image: map['image'],
        );

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  const ContactModel.empty()
      : this(
          phoneNumber: "empty.phoneNumber",
          name: "empty.name",
          id: "empty.id",
          image: defaultImageUrl,
        );
}
