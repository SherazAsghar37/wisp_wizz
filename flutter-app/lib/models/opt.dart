// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class OtpVerification extends Equatable {
  final String phoneNumber;
  final String otp;
  const OtpVerification({required this.otp, required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber, otp];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }

  OtpVerification.fromMap(Map<String, dynamic> map)
      : this(
          phoneNumber: map['phoneNumber'] as String,
          otp: map['otp'] as String,
        );

  String toJson() => json.encode(toMap());

  factory OtpVerification.fromJson(String source) =>
      OtpVerification.fromMap(json.decode(source) as Map<String, dynamic>);
}
