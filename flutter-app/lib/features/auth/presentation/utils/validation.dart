import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';

Either<ValidationFailure, bool> sendCodeValidation(
    int phoneNumber, String countryCode) {
  if (countryCode.isEmpty) {
    return const Left(
        ValidationFailure(message: "Country Code cannot be empty"));
  } else if (phoneNumber < 10000000) {
    return const Left(ValidationFailure(message: "Invalied phone number"));
  } else {
    return const Right(true);
  }
}

Either<ValidationFailure, bool> verifyOtpValidation(int phoneNumber, int otp) {
  if (otp < 100000) {
    return const Left(ValidationFailure(message: "Invalid code"));
  } else if (phoneNumber < 8) {
    return const Left(ValidationFailure(message: "Invalied phone number"));
  } else {
    return const Right(true);
  }
}

Either<ValidationFailure, bool> loginValidation(
    String countryCode, String? name, int phoneNumber, File? image) {
  if (countryCode.isEmpty) {
    return const Left(
        ValidationFailure(message: "Country Code cannot be empty"));
  } else if (phoneNumber < 10000000) {
    return const Left(ValidationFailure(message: "Invalied phone number"));
  } else {
    return const Right(true);
  }
}
