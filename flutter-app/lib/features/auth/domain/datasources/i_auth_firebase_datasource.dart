// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';

abstract class IAuthFirebaseDatasource {
  final FirebaseAuth _auth;
  final PhoneAuthProviderWrapper _phoneAuthProviderWrapper;
  IAuthFirebaseDatasource(
      {required FirebaseAuth auth,
      required PhoneAuthProviderWrapper phoneAuthProviderWrapper})
      : _auth = auth,
        _phoneAuthProviderWrapper = phoneAuthProviderWrapper;

  Future<CustomPhoneResoponse> sendCode({
    required String phoneNumber,
  });

  Future<PhoneAuthCredential> verifyOTP({
    required String verificationId,
    required String otp,
  });
  Future<UserCredential> getUserByCradentials({
    required PhoneAuthCredential phoneAuthCredential,
  });
}
