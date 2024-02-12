part of 'auth_firebase_datasource.dart';

class PhoneAuthProviderWrapper {
  PhoneAuthCredential credential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
  }
}
