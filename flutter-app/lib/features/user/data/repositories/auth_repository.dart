import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
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
      Uint8List? image}) async {
    try {
      final response = await _remoteDatasource.loginUser(
          name: name, phoneNumber: phoneNumber, image: image);
      await _localDataSource.cacheUserData(response);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
      // } catch (e) {
      //   return Left(ApiFailure(message: e.toString(), statusCode: 500));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
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
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
      // } catch (e) {
      //   return Left(ApiFailure(message: e.toString(), statusCode: 500));
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
      // } catch (e) {
      //   return Left(ApiFailure(message: e.toString(), statusCode: 500));
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
    }
  }
}
