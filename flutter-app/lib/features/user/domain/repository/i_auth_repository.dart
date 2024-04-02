import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/app/shared/entities/user_entity.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';

abstract class IAuthRepository {
  ResultFuture<CustomPhoneResoponse> sendCode({
    required String phoneNumber,
  });
  ResultFuture<PhoneAuthCredential> verifyOTP(
      {required String verificationId, required String otp});
  FutureUser loginUser({
    required String? name,
    required String phoneNumber,
    Uint8List? image,
  });
  FutureNullabeleUser getUser({
    required String phoneNumber,
  });
  NullabeleUser getCachedUser();
  FutureVoid logout();

  Result<void> initSocket(String userId);
  Result<void> disconnectSocket();
  FutureUser updateUser({
    required String? name,
    required String id,
    Uint8List? image,
  });

  ResultFuture<void> cacheUser(UserModel user);
  ResultFuture<UserEntity?> initApplication();
}

abstract class ICustomPhoneResponse {
  final String verificationId;
  final PhoneAuthCredential? phoneAuthCredential;
  ICustomPhoneResponse(
      {required this.verificationId, this.phoneAuthCredential});
}
