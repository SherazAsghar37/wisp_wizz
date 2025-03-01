import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/constants/status_codes.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/user/domain/datasources/i_auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';
part 'phone_auth_provider_wrapper.dart';

class AuthFirebaseDatasource implements IAuthFirebaseDatasource {
  final FirebaseAuth _auth;
  final PhoneAuthProviderWrapper _phoneAuthProviderWrapper;
  AuthFirebaseDatasource(
      {required FirebaseAuth auth,
      required PhoneAuthProviderWrapper phoneAuthProviderWrapper})
      : _auth = auth,
        _phoneAuthProviderWrapper = phoneAuthProviderWrapper;

  @override
  Future<CustomPhoneResoponse> sendCode({
    required String phoneNumber,
  }) async {
    try {
      PhoneAuthCredential? phoneAuthCredential;
      // ignore: no_leading_underscores_for_local_identifiers
      String _verificationId = "";
      Completer<CustomPhoneResoponse> completer = Completer();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          phoneAuthCredential = credential;
          completer.complete(CustomPhoneResoponse(
            verificationId: _verificationId,
            phoneAuthCredential: phoneAuthCredential,
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          DebugHelper.printError(e.toString());
          completer.complete(CustomPhoneResoponse(
            verificationId: _verificationId,
            phoneAuthCredential: null,
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            _verificationId = verificationId;
            completer.complete(CustomPhoneResoponse(
              verificationId: _verificationId,
              phoneAuthCredential: phoneAuthCredential,
            ));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            _verificationId = verificationId;
            completer.complete(CustomPhoneResoponse(
              verificationId: _verificationId,
              phoneAuthCredential: phoneAuthCredential,
            ));
          }
        },
      );

      return completer.future;
    } on ApiException {
      DebugHelper.printError("Got api exception");
      rethrow;
    } catch (e) {
      DebugHelper.printError("Code Sending Exception: ${e.toString()}");
      throw const ApiException(
        message: "Failed to send code, please try again later",
        statusCode: StatusCode.FORBIDDEN,
      );
    }
  }

  @override
  Future<PhoneAuthCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential phoneAuthCredential = _phoneAuthProviderWrapper
          .credential(verificationId: verificationId, smsCode: otp);
      await getUserByCradentials(phoneAuthCredential: phoneAuthCredential);
      return phoneAuthCredential;
    } on FirebaseAuthException catch (authException) {
      DebugHelper.printError("FirebaseAuthException: ${authException.message}");
      throw const ApiException(
          message: "Invalid OTP", statusCode: StatusCode.FORBIDDEN);
    } on ApiException {
      rethrow;
    } catch (e) {
      DebugHelper.printError("Varification Code Exception: ${e.toString()}");
      throw const ApiException(
          message: "Invalid OTP", statusCode: StatusCode.FORBIDDEN);
    }
  }

  @override
  Future<UserCredential> getUserByCradentials({
    required PhoneAuthCredential phoneAuthCredential,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      return userCredential;
    } on FirebaseAuthException catch (authException) {
      DebugHelper.printError("FirebaseAuthException: ${authException.message}");
      throw const ApiException(
          message: "User Not found", statusCode: StatusCode.FORBIDDEN);
    } on ApiException {
      rethrow;
    } catch (e) {
      DebugHelper.printError("Firebase User Info Exception: ${e.toString()}");
      throw const ApiException(
          message: "User Not found", statusCode: StatusCode.FORBIDDEN);
    }
  }
}
