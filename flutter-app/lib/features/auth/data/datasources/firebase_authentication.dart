import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/constants/status_codes.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
part './phone_auth_provider.dart';

class FirebaseAuthentication {
  final FirebaseAuth _auth;
  final PhoneAuthProviderWrapper _phoneAuthProviderWrapper;
  FirebaseAuthentication(
      {required FirebaseAuth auth,
      required PhoneAuthProviderWrapper phoneAuthProviderWrapper})
      : _auth = auth,
        _phoneAuthProviderWrapper = phoneAuthProviderWrapper;

  Future<CustomPhoneResoponse> sendCode(
      {required String phoneNumber, required String countryCode}) async {
    try {
      PhoneAuthCredential? phoneAuthCredential;
      // ignore: no_leading_underscores_for_local_identifiers
      String _verificationId = "";
      Completer<CustomPhoneResoponse> completer = Completer();

      await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          phoneAuthCredential = credential;
          completer.complete(CustomPhoneResoponse(
            verificationId: _verificationId,
            phoneAuthCredential: phoneAuthCredential,
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          DebugHelper.printError("FirebaseAuthException: ${e.toString()}");
          completer.completeError(const ApiException(
            message: "Failed to send code, please try again later",
            statusCode: StatusCode.FORBIDDEN,
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          completer.complete(CustomPhoneResoponse(
            verificationId: _verificationId,
            phoneAuthCredential: phoneAuthCredential,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          completer.complete(CustomPhoneResoponse(
            verificationId: _verificationId,
            phoneAuthCredential: phoneAuthCredential,
          ));
        },
      );

      return completer.future;
    } on ApiException {
      rethrow;
    } catch (e) {
      DebugHelper.printError("Exception: ${e.toString()}");
      throw const ApiException(
        message: "Failed to send code, please try again later",
        statusCode: StatusCode.FORBIDDEN,
      );
    }
  }

  Future<PhoneAuthCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential phoneAuthCredential = _phoneAuthProviderWrapper
          .credential(verificationId: verificationId, smsCode: otp);

      return phoneAuthCredential;
    } on FirebaseAuthException catch (authException) {
      DebugHelper.printError("FirebaseAuthException: ${authException.message}");
      throw const ApiException(
          message: "Invalid OTP", statusCode: StatusCode.FORBIDDEN);
    } on ApiException {
      rethrow;
    } catch (e) {
      DebugHelper.printError("Exception: ${e.toString()}");
      throw const ApiException(
          message: "Invalid OTP", statusCode: StatusCode.FORBIDDEN);
    }
  }
}
