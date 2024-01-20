import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';

class MRemoteDatasource extends Mock implements RemoteDatasource {}

void main() {
  late AuthRepository authRepository;
  late RemoteDatasource remoteDatasource;

  setUp(() {
    remoteDatasource = MRemoteDatasource();
    authRepository = AuthRepository(remoteDataSource: remoteDatasource);
  });

  final params = CustomUserParam(
      countryCode: "whatever.countryCode",
      name: "whatever.name",
      phoneNumber: 123456789,
      image: File("whatever.file"));
  final otpParams = CustomVerificationParam(
    otp: 123456,
    phoneNumber: 123456789,
  );

  const String message = 'whatever.message';
  const int statusCode = 500;
  final UserModel user = UserModel.empty();
  group("[Auth reposiotry Implementation] - ", () {
    group("[Login User] - ", () {
      test(
          "It should call remoteDataSource.loginUser and return void by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.loginUser(
            name: any(named: "name"),
            phoneNumber: any(named: "phoneNumber"),
            countryCode: any(named: "countryCode"),
            image: any(named: "image"))).thenAnswer((invocation) async => user);
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image);
        //Assert
        expect(response, Right<dynamic, UserModel>(user));
        verify(
          () => remoteDatasource.loginUser(
              name: params.name,
              phoneNumber: params.phoneNumber,
              countryCode: params.countryCode,
              image: params.image),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call remoteDataSource.loginUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.loginUser(
                name: any(named: "name"),
                phoneNumber: any(named: "phoneNumber"),
                countryCode: any(named: "countryCode"),
                image: any(named: "image")))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image);
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(() => remoteDatasource.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image)).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
    group("[Verify OTP] - ", () {
      test(
          "It should call remoteDataSource.verifyOTP and return void by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.verifyOTP(
              otp: any(named: "otp"),
              phoneNumber: any(named: "phoneNumber"),
            )).thenAnswer((invocation) async => const Right(null));
        //Act
        final response = await authRepository.verifyOTP(
          otp: otpParams.otp,
          phoneNumber: otpParams.phoneNumber,
        );
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => remoteDatasource.verifyOTP(
            otp: otpParams.otp,
            phoneNumber: otpParams.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call remoteDataSource.verifyOTP and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.verifyOTP(
                  otp: any(named: "otp"),
                  phoneNumber: any(named: "phoneNumber"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.verifyOTP(
          otp: otpParams.otp,
          phoneNumber: otpParams.phoneNumber,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(
          () => remoteDatasource.verifyOTP(
            otp: otpParams.otp,
            phoneNumber: otpParams.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
    group("[Send Code] - ", () {
      test(
          "It should call remoteDataSource.sendCode and return void by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.sendCode(
              phoneNumber: any(named: "phoneNumber"),
              countryCode: any(named: "countryCode"),
            )).thenAnswer((invocation) async => const Right(null));
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => remoteDatasource.sendCode(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call remoteDataSource.sendCode and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.sendCode(
                  phoneNumber: any(named: "phoneNumber"),
                  countryCode: any(named: "countryCode"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(
          () => remoteDatasource.sendCode(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
  });
}
