import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wisp_wizz/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';

import '../../../../app/temp_path.dart';
import '../../global/phone_auth_cradentials.mock.dart';

class MRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MFirebaseAuthentication extends Mock implements AuthFirebaseDatasource {}

class MLocalDatasource extends Mock implements AuthLocalDatasource {}

void main() {
  late AuthRepository authRepository;
  late AuthRemoteDatasource remoteDatasource;
  late MFirebaseAuthentication firebaseAuthentication;
  late PhoneAuthCredential phoneAuthCredential;
  late AuthLocalDatasource localDatasource;

  setUp(() {
    remoteDatasource = MRemoteDatasource();
    firebaseAuthentication = MFirebaseAuthentication();
    localDatasource = MLocalDatasource();
    authRepository = AuthRepository(
        remoteDataSource: remoteDatasource,
        firebaseAuthentication: firebaseAuthentication,
        localDataSource: localDatasource);
    phoneAuthCredential = MPhoneAuthCradential();
  });

  final params = CustomUserParam(
      name: "whatever.name",
      phoneNumber: "+92123456789",
      image: tempFile.readAsBytesSync());

  const otpParams = CustomVerificationParam(
    otp: "123456",
    verificationId: "123456789",
  );

  const phoneParams = CustomPhoneParam(
    phoneNumber: "123456789",
  );
  const String verificationId = "1234";
  const customPhoneResoponse =
      CustomPhoneResoponse(verificationId: verificationId);

  const String message = 'whatever.message';
  const int statusCode = 500;
  final UserModel user = UserModel.empty();
  group("[Auth reposiotry Implementation] - ", () {
    group("[Login User] - ", () {
      test(
          "It should call remoteDataSource.loginUser and return userModel by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.loginUser(
            name: any(named: "name"),
            phoneNumber: any(named: "phoneNumber"),
            image: any(named: "image"))).thenAnswer((invocation) async => user);
        when(() => localDatasource.cacheUserData(user))
            .thenAnswer((invocation) async => Future.value());
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            image: params.image);
        //Assert
        expect(response, Right<dynamic, UserModel>(user));
        verify(
          () => remoteDatasource.loginUser(
              name: params.name,
              phoneNumber: params.phoneNumber,
              image: params.image),
        ).called(1);
        verify(
          () => localDatasource.cacheUserData(user),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
        verifyNoMoreInteractions(localDatasource);
      });

      test(
          "It should call remoteDataSource.loginUser throw cache exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.loginUser(
            name: any(named: "name"),
            phoneNumber: any(named: "phoneNumber"),
            image: any(named: "image"))).thenAnswer((invocation) async => user);
        when(() => localDatasource.cacheUserData(user)).thenThrow(
            const CacheException(message: "Failed to cache user data"));
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            image: params.image);
        //Assert
        expect(
            response,
            const Left<CacheFailure, dynamic>(
                CacheFailure(message: "Failed to cache user data")));
        verify(
          () => remoteDatasource.loginUser(
              name: params.name,
              phoneNumber: params.phoneNumber,
              image: params.image),
        ).called(1);
        verify(
          () => localDatasource.cacheUserData(user),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
        verifyNoMoreInteractions(localDatasource);
      });
      test(
          "It should call remoteDataSource.loginUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.loginUser(
                name: any(named: "name"),
                phoneNumber: any(named: "phoneNumber"),
                image: any(named: "image")))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            image: params.image);
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(() => remoteDatasource.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            image: params.image)).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
    group("[Verify OTP] - ", () {
      test(
          "It should call firebaseAuthentication.verifyOTP and return void by calling only once",
          () async {
        //Arrange
        when(() => firebaseAuthentication.verifyOTP(
              otp: any(named: "otp"),
              verificationId: any(named: "verificationId"),
            )).thenAnswer((invocation) async => phoneAuthCredential);
        //Act
        final response = await authRepository.verifyOTP(
          otp: otpParams.otp,
          verificationId: otpParams.verificationId,
        );
        //Assert
        expect(
            response, Right<dynamic, PhoneAuthCredential>(phoneAuthCredential));
        verify(
          () => firebaseAuthentication.verifyOTP(
            otp: otpParams.otp,
            verificationId: otpParams.verificationId,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call firebaseAuthentication.verifyOTP and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => firebaseAuthentication.verifyOTP(
                  otp: any(named: "otp"),
                  verificationId: any(named: "verificationId"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.verifyOTP(
          otp: otpParams.otp,
          verificationId: otpParams.verificationId,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(
          () => firebaseAuthentication.verifyOTP(
            otp: otpParams.otp,
            verificationId: otpParams.verificationId,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
    group("[Send Code] - ", () {
      test(
          "It should call firebaseAuthentication.sendCode and return void by calling only once",
          () async {
        //Arrange
        when(() => firebaseAuthentication.sendCode(
              phoneNumber: any(named: "phoneNumber"),
            )).thenAnswer((invocation) async => customPhoneResoponse);
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: phoneParams.phoneNumber,
        );
        //Assert
        expect(response,
            const Right<dynamic, CustomPhoneResoponse>(customPhoneResoponse));
        verify(
          () => firebaseAuthentication.sendCode(
            phoneNumber: phoneParams.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call firebaseAuthentication.sendCode and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => firebaseAuthentication.sendCode(
                  phoneNumber: any(named: "phoneNumber"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: phoneParams.phoneNumber,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(
          () => firebaseAuthentication.sendCode(
            phoneNumber: phoneParams.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });
    group("[Get User] - ", () {
      test(
          "It should call remoteDataSource.getUSer and return UserModel by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.getUser(
              phoneNumber: any(named: "phoneNumber"),
            )).thenAnswer((invocation) async => user);
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(response, Right<dynamic, UserModel>(user));
        verify(
          () => remoteDatasource.getUser(
            phoneNumber: params.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call remoteDataSource.getUSer and return null by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.getUser(
              phoneNumber: any(named: "phoneNumber"),
            )).thenAnswer((invocation) async => null);
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => remoteDatasource.getUser(
            phoneNumber: params.phoneNumber,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
      test(
          "It should call remoteDataSource.getUser and throw api exception by calling only once",
          () async {
        //Arrange
        when(() => remoteDatasource.getUser(
                  phoneNumber: any(named: "phoneNumber"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(() => remoteDatasource.getUser(
              phoneNumber: params.phoneNumber,
            )).called(1);
        verifyNoMoreInteractions(remoteDatasource);
      });
    });

    group("[Get Cached User] - ", () {
      test(
          "It should call localDatasource.getCachedUser and return UserModel by calling only once",
          () async {
        //Arrange
        when(() => localDatasource.getCachedUserData())
            .thenAnswer((invocation) => user);
        //Act
        final response = authRepository.getCachedUser();
        //Assert
        expect(response, Right<dynamic, UserModel>(user));
        verify(
          () => localDatasource.getCachedUserData(),
        ).called(1);
        verifyNoMoreInteractions(localDatasource);
      });
      test(
          "It should call localDatasource.getCachedUser and return null by calling only once",
          () async {
        //Arrange
        when(() => localDatasource.getCachedUserData())
            .thenAnswer((invocation) => null);
        //Act
        final response = authRepository.getCachedUser();
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => localDatasource.getCachedUserData(),
        ).called(1);
        verifyNoMoreInteractions(localDatasource);
      });
      test(
          "It should calllocalDatasource.getCachedUser and throw cache exception by calling only once",
          () async {
        //Arrange
        when(() => localDatasource.getCachedUserData())
            .thenThrow(const CacheException(
          message: "Failed to cache user data",
        ));
        //Act
        final response = authRepository.getCachedUser();
        //Assert
        expect(
            response,
            const Left<CacheFailure, dynamic>(
                CacheFailure(message: "Failed to cache user data")));
        verify(
          () => localDatasource.getCachedUserData(),
        ).called(1);
        verifyNoMoreInteractions(localDatasource);
      });
    });
    group("[Logout User] - ", () {
      test(
          "It should call localDatasource.removeCachedUser and return null by calling only once",
          () async {
        //Arrange
        when(() => localDatasource.removeCachedUser())
            .thenAnswer((invocation) async => Future.value());
        //Act
        final response = await authRepository.logout();
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => localDatasource.removeCachedUser(),
        ).called(1);
        verifyNoMoreInteractions(localDatasource);
      });

      test(
          "It should calllocalDatasource.removeCachedUser and throw cache exception by calling only once",
          () async {
        //Arrange
        when(() => localDatasource.removeCachedUser())
            .thenThrow(const CacheException(
          message: "Failed to cache user data",
        ));
        //Act
        final response = await authRepository.logout();
        //Assert
        expect(
            response,
            const Left<CacheFailure, dynamic>(
                CacheFailure(message: "Failed to cache user data")));
        verify(
          () => localDatasource.removeCachedUser(),
        ).called(1);
        verifyNoMoreInteractions(localDatasource);
      });
    });
  });
}
