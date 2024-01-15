import 'package:wisp_wizz/features/app/utils/app_enums.dart';
import 'package:wisp_wizz/models/user.dart';

abstract class IAuthRepository {
  Future<void> sendCode(
      {required int phoneNumber, required CountryCodes countryCode});
  Future<void> verify(
      {required int phoneNumber, required int verificationCode});
  Future<void> loginUser(User user);
}
