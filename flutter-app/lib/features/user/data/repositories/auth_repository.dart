import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/constants/status_codes.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_local_data_source.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_remote_data_source.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthFirebaseDatasource _firebaseAuthentication;
  final AuthLocalDatasource _localDataSource;
  AuthRepository(
      {required AuthRemoteDatasource remoteDataSource,
      required AuthFirebaseDatasource firebaseAuthentication,
      required AuthLocalDatasource localDataSource})
      : _remoteDatasource = remoteDataSource,
        _firebaseAuthentication = firebaseAuthentication,
        _localDataSource = localDataSource;

  @override
  FutureUser loginUser(
      {required String? name,
      required String phoneNumber,
      Uint8List? image,
      String? mimeType}) async {
    try {
      final response = await _remoteDatasource.loginUser(
          name: name, phoneNumber: phoneNumber, image: image);
      // _remoteDatasource.connectSocket(response.id);

      await _localDataSource.cacheUserData(response);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }

  @override
  ResultFuture<CustomPhoneResoponse> sendCode({
    required String phoneNumber,
  }) async {
    try {
      final response = await _firebaseAuthentication.sendCode(
        phoneNumber: phoneNumber,
      );
      if (response.phoneAuthCredential == null &&
          response.verificationId.isEmpty) {
        return const Left(ApiFailure(
            message: "unable to send code, please try again",
            statusCode: StatusCode.FORBIDDEN));
      }
      return Right(response);
    } on ApiException catch (e) {
      DebugHelper.printError("exception");
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<PhoneAuthCredential> verifyOTP(
      {required String verificationId, required String otp}) async {
    try {
      final response = await _firebaseAuthentication.verifyOTP(
          verificationId: verificationId, otp: otp);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserModel?> getUser({
    required String phoneNumber,
  }) async {
    try {
      final response = await _remoteDatasource.getUser(
        phoneNumber: phoneNumber,
      );

      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  Result<UserModel?> getCachedUser() {
    try {
      final response = _localDataSource.getCachedUserData();

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  FutureVoid logout() async {
    try {
      final response = await _localDataSource.removeCachedUser();

      return Right(response);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }

  @override
  FutureUser updateUser(
      {required String? name,
      required String id,
      Uint8List? image,
      String? mimeType}) async {
    try {
      final response =
          await _remoteDatasource.updateUser(name: name, id: id, image: image);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> cacheUser(UserModel user) async {
    try {
      await _localDataSource.cacheUserData(user);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<UserModel?> initApplication() async {
    try {
      await _localDataSource.initLocalDB();
      final user = _localDataSource.getCachedUserData();
      // if (user != null) {
      //   _remoteDatasource.connectSocket(user.id);
      // }
      return Right(user);
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    } on SqfliteDBException catch (e) {
      return Left(SqfliteDBFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  Result<void> initSocket(String userId) {
    try {
      _remoteDatasource.connectSocket(userId);
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }

  @override
  Result<void> disconnectSocket() {
    try {
      _remoteDatasource.disconnectSocket();
      return const Right(null);
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }

  @override
  FutureVoid deleteUser({required String id}) async {
    try {
      await _localDataSource.removeCachedUser();
      final bool response = await _remoteDatasource.deleteUser(id: id);
      return response
          ? const Right(null)
          : const Left(
              ApiFailure(message: "Unable to delete user", statusCode: 500));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } on WebSocketException catch (e) {
      return Left(WebSocketFailure.fromException(e));
    }
  }
}
