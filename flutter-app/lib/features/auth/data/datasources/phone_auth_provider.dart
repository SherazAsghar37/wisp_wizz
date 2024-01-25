part of "./firebase_authentication.dart";

class PhoneAuthProviderWrapper {
  PhoneAuthCredential credential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
  }
}
