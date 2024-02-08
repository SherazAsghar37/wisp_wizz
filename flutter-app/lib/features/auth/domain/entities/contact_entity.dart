// ignore_for_file: unused_field

import 'dart:typed_data';

class ContactEntity {
  final String? phoneNumber;
  final String? _id;
  final Uint8List userProfile;
  ContactEntity(
      {required String id,
      required this.phoneNumber,
      required this.userProfile})
      : _id = id;
}
