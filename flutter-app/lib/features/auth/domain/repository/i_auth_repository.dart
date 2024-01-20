import 'dart:io';

import 'package:wisp_wizz/features/app/utils/typedef.dart';

abstract class IAuthRepository {
  FutureVoid sendCode({required int phoneNumber, required String countryCode});
  FutureVoid verifyOTP({required int phoneNumber, required int otp});
  FutureUser loginUser(
      {required String? name,
      required int phoneNumber,
      required String countryCode,
      File? image});
}
