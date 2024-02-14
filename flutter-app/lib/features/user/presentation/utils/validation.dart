import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';

Either<ValidationFailure, bool> sendCodeValidation(String phoneNumber) {
  if (!phoneNumber.startsWith("+")) {
    return const Left(ValidationFailure(message: "Invalid phone number"));
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
  String? name,
  String phoneNumber,
) {
  if (!phoneNumber.startsWith("+")) {
    return const Left(ValidationFailure(message: "Invalid phone number"));
  } else if (phoneNumber.length < 7) {
    return const Left(ValidationFailure(message: "Invalid phone number"));
  } else {
    return const Right(true);
  }
}

Either<ValidationFailure, bool> updateUserVaidation(
  String id,
) {
  if (id.isEmpty) {
    return const Left(ValidationFailure(message: "Invalid ID"));
  } else {
    return const Right(true);
  }
}
