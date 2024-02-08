// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String? phoneNumber;
  final String? _id;
  final Uint8List image;
  const ContactEntity(
      {required String id, required this.phoneNumber, required this.image})
      : _id = id;

  @override
  List<Object?> get props => [phoneNumber, _id, image];
}
