import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';

abstract class IAuthRepository {
  ResultFuture<CustomPhoneResoponse> sendCode(
      {required String phoneNumber, required String countryCode});
  ResultFuture<PhoneAuthCredential> verifyOTP(
      {required String verificationId, required String otp});
  FutureUser loginUser(
      {required String? name,
      required int phoneNumber,
      required String countryCode,
      String? image});
  FutureNullabeleUser getUser({
    required int phoneNumber,
    required String countryCode,
  });
  NullabeleUser getCachedUser();
}

abstract class ICustomPhoneResponse {
  final String verificationId;
  final PhoneAuthCredential? phoneAuthCredential;
  ICustomPhoneResponse(
      {required this.verificationId, this.phoneAuthCredential});
}
