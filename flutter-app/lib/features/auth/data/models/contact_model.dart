// ignore_for_file: overridden_fields

import 'dart:typed_data';

import 'package:wisp_wizz/features/auth/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  // ignore: unused_field
  final String _id;
  @override
  final String phoneNumber;
  @override
  final Uint8List image;
  const ContactModel(
      {required String id, required this.phoneNumber, required this.image})
      : _id = id,
        super(id: id, phoneNumber: phoneNumber, image: image);
}
