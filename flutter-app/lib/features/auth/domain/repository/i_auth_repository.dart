import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';

abstract class IAuthRepository {
  ResultFuture<CustomPhoneResoponse> sendCode({
    required String phoneNumber,
  });
  ResultFuture<PhoneAuthCredential> verifyOTP(
      {required String verificationId, required String otp});
  FutureUser loginUser(
      {required String? name, required String phoneNumber, String? image});
  FutureNullabeleUser getUser({
    required String phoneNumber,
  });
  NullabeleUser getCachedUser();
  FutureVoid logout();
}

abstract class ICustomPhoneResponse {
  final String verificationId;
  final PhoneAuthCredential? phoneAuthCredential;
  ICustomPhoneResponse(
      {required this.verificationId, this.phoneAuthCredential});
}
