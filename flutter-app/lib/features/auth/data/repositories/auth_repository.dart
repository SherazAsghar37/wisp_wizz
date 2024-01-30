import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/datasources/firebase_authentication.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';

class AuthRepository implements IAuthRepository {
  final RemoteDatasource _remoteDatasource;
  final FirebaseAuthentication _firebaseAuthentication;
  AuthRepository(
      {required RemoteDatasource remoteDataSource,
      required FirebaseAuthentication firebaseAuthentication})
      : _remoteDatasource = remoteDataSource,
        _firebaseAuthentication = firebaseAuthentication;
  @override
  FutureUser loginUser(
      {required String? name,
      required int phoneNumber,
      required String countryCode,
      String? image}) async {
    try {
      final response = await _remoteDatasource.loginUser(
          name: name,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          image: image);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
      // } catch (e) {
      //   return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<CustomPhoneResoponse> sendCode(
      {required String phoneNumber, required String countryCode}) async {
    try {
      final response = await _firebaseAuthentication.sendCode(
          phoneNumber: phoneNumber, countryCode: countryCode);
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
  ResultFuture<UserModel?> getUser(
      {required int phoneNumber, required String countryCode}) async {
    try {
      final response = await _remoteDatasource.getUser(
          phoneNumber: phoneNumber, countryCode: countryCode);

      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
