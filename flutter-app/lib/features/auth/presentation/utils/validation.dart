import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';

Either<ValidationFailure, bool> sendCodeValidation(
    String phoneNumber, String countryCode) {
  if (countryCode.isEmpty) {
    return const Left(
        ValidationFailure(message: "Country Code cannot be empty"));
  } else if (phoneNumber.length < 7) {
    return const Left(ValidationFailure(message: "Invalid phone number"));
  } else {
    return const Right(true);
  }
}

Either<ValidationFailure, bool> verifyOtpValidation(String otp) {
  if (otp.isEmpty || otp.length < 6) {
    return const Left(ValidationFailure(message: "Invalid OTP"));
  } else {
    return const Right(true);
  }
}

Either<ValidationFailure, bool> loginValidation(
    String countryCode, String? name, int phoneNumber, File? image) {
  if (countryCode.isEmpty) {
    return const Left(
        ValidationFailure(message: "Country Code cannot be empty"));
  } else if (phoneNumber < 1000000) {
    return const Left(ValidationFailure(message: "Invalid phone number"));
  } else {
    return const Right(true);
  }
}
