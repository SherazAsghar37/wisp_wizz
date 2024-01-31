import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/datasources/firebase_authentication.dart';
import 'package:wisp_wizz/features/auth/data/datasources/local_data_source.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';

import '../../global/phone_auth_cradentials.mock.dart';

class MRemoteDatasource extends Mock implements RemoteDatasource {}

class MFirebaseAuthentication extends Mock implements FirebaseAuthentication {}

class MLocalDatasource extends Mock implements LocalDatasource {}

void main() {
  late AuthRepository authRepository;
  late RemoteDatasource remoteDatasource;
  late MFirebaseAuthentication firebaseAuthentication;
  late PhoneAuthCredential phoneAuthCredential;
  late LocalDatasource localDatasource;

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

  const params = CustomUserParam(
      countryCode: "whatever.countryCode",
      name: "whatever.name",
      phoneNumber: 123456789,
      image: "whatever.image");

  const otpParams = CustomVerificationParam(
    otp: "123456",
    verificationId: "123456789",
  );

  const phoneParams = CustomPhoneParam(
    countryCode: "+92",
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
            countryCode: any(named: "countryCode"),
            image: any(named: "image"))).thenAnswer((invocation) async => user);
        when(() => localDatasource.cacheUserData(user))
            .thenAnswer((invocation) async => Future.value());
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
            countryCode: any(named: "countryCode"),
            image: any(named: "image"))).thenAnswer((invocation) async => user);
        when(() => localDatasource.cacheUserData(user)).thenThrow(
            const CacheException(message: "Failed to cache user data"));
        //Act
        final response = await authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
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
              countryCode: params.countryCode,
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
              countryCode: any(named: "countryCode"),
            )).thenAnswer((invocation) async => customPhoneResoponse);
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: phoneParams.phoneNumber,
          countryCode: phoneParams.countryCode,
        );
        //Assert
        expect(response,
            const Right<dynamic, CustomPhoneResoponse>(customPhoneResoponse));
        verify(
          () => firebaseAuthentication.sendCode(
            phoneNumber: phoneParams.phoneNumber,
            countryCode: phoneParams.countryCode,
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
                  countryCode: any(named: "countryCode"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.sendCode(
          phoneNumber: phoneParams.phoneNumber,
          countryCode: phoneParams.countryCode,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(
          () => firebaseAuthentication.sendCode(
            phoneNumber: phoneParams.phoneNumber,
            countryCode: phoneParams.countryCode,
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
              countryCode: any(named: "countryCode"),
            )).thenAnswer((invocation) async => user);
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, Right<dynamic, UserModel>(user));
        verify(
          () => remoteDatasource.getUser(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
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
              countryCode: any(named: "countryCode"),
            )).thenAnswer((invocation) async => null);
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(response, const Right<dynamic, void>(null));
        verify(
          () => remoteDatasource.getUser(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
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
                  countryCode: any(named: "countryCode"),
                ))
            .thenThrow(
                const ApiException(message: message, statusCode: statusCode));
        //Act
        final response = await authRepository.getUser(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        );
        //Assert
        expect(
            response,
            const Left<ApiFailure, dynamic>(
                ApiFailure(message: message, statusCode: statusCode)));
        verify(() => remoteDatasource.getUser(
              phoneNumber: params.phoneNumber,
              countryCode: params.countryCode,
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
