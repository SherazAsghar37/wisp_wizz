import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/domain/repository/auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final RemoteDatasource _remoteDatasource;
  AuthRepository({required RemoteDatasource remoteDataSource})
      : _remoteDatasource = remoteDataSource;
  @override
  FutureVoid loginUser(
      {required String name,
      required int phoneNumber,
      required String countryCode,
      File? image}) async {
    try {
      await _remoteDatasource.loginUser(
          name: name,
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          image: image);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  FutureVoid sendCode(
      {required int phoneNumber, required String countryCode}) async {
    try {
      await _remoteDatasource.sendCode(
          phoneNumber: phoneNumber, countryCode: countryCode);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  FutureVoid verifyOTP({required int phoneNumber, required int otp}) async {
    try {
      await _remoteDatasource.verifyOTP(phoneNumber: phoneNumber, otp: otp);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }
}
