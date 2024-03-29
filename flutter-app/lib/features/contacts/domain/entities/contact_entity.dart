import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String? phoneNumber;
  final String? name;
  final String? _id;
  final String? image;
  const ContactEntity(
      {required String id,
      required this.phoneNumber,
      required this.image,
      required this.name})
      : _id = id;

  @override
  List<Object?> get props => [phoneNumber, _id, image, name];
}
