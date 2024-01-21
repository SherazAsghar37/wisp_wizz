import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../../app/temp_path.dart';

class MSendCode extends Mock implements SendCode {}

class MVerifyOTP extends Mock implements VerifyOTP {}

class MLoginUser extends Mock implements LoginUser {}

void main() {
  late SendCode sendCode;
  late VerifyOTP verifyOTP;
  late LoginUser loginUser;
  late AuthBloc authBloc;

  const String countryCode = "whatever.countryCode";
  const int phoneNumber = 123456890;
  const int otp = 123456;
  const String name = "whatever.name";
  File? image = tempFile;

  const ApiFailure apiFailure =
      ApiFailure(message: "whatever.message", statusCode: 500);

  setUp(() {
    sendCode = MSendCode();
    verifyOTP = MVerifyOTP();
    loginUser = MLoginUser();
    authBloc = AuthBloc(
        loginUser: loginUser, sendCode: sendCode, verifyOTP: verifyOTP);

    registerFallbackValue(const CustomPhoneParam(
        phoneNumber: phoneNumber, countryCode: countryCode));
    registerFallbackValue(
        const CustomVerificationParam(phoneNumber: phoneNumber, otp: otp));
    registerFallbackValue(CustomUserParam(
        countryCode: countryCode,
        name: name,
        phoneNumber: phoneNumber,
        image: image));
  });
  tearDown(() => authBloc.close());

  group("[Auth Bloc] - ", () {
    test("initial state should be", () {
      expect(authBloc.state, equals(const AuthInitial()));
    });
    group("[Send code] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[AuthSendingCode(), AuthCodeSent()] when MyEvent is added.',
          build: () {
            when(() => sendCode(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(const SendCodeEvent(
              countryCode: countryCode, phoneNumber: phoneNumber)),
          expect: () =>
              <AuthState>[const AuthSendingCode(), const AuthCodeSent()],
          verify: (bloc) {
            verify(() => sendCode(const CustomPhoneParam(
                phoneNumber: phoneNumber, countryCode: countryCode))).called(1);
            verifyNoMoreInteractions(sendCode);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthSendingCode(),AuthCodeSentFailed()] when countrycode validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
            const SendCodeEvent(countryCode: "", phoneNumber: phoneNumber)),
        expect: () => <AuthState>[
          const AuthSendingCode(),
          const AuthCodeSentFailed("Country Code cannot be empty")
        ],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [AuthSendingCode(),AuthCodeSentFailed()] when phone validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(
            const SendCodeEvent(countryCode: countryCode, phoneNumber: 123456)),
        expect: () => <AuthState>[
          const AuthSendingCode(),
          const AuthCodeSentFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthSendingCode(),AuthCodeSentFailed()] when MyEvent is added.',
          build: () {
            when(() => sendCode(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const SendCodeEvent(
              countryCode: countryCode, phoneNumber: phoneNumber)),
          expect: () => <AuthState>[
                const AuthSendingCode(),
                AuthCodeSentFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => sendCode(const CustomPhoneParam(
                phoneNumber: phoneNumber, countryCode: countryCode))).called(1);
            verifyNoMoreInteractions(sendCode);
          });
    });
    group("[Verify Otp] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyingOTP(), const AuthOTPVerified()] when MyEvent is added.',
          build: () {
            when(() => verifyOTP(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc
              .add(const VerifyOTPEvent(phoneNumber: phoneNumber, otp: otp)),
          expect: () =>
              <AuthState>[const AuthVerifyingOTP(), const AuthOTPVerified()],
          verify: (bloc) {
            verify(() => verifyOTP(const CustomVerificationParam(
                phoneNumber: phoneNumber, otp: otp))).called(1);
            verifyNoMoreInteractions(verifyOTP);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when otp validation fails',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(const VerifyOTPEvent(phoneNumber: phoneNumber, otp: 1234)),
        expect: () => <AuthState>[
          const AuthVerifyingOTP(),
          const AuthOTPVerificationFailed("Invalid code")
        ],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when phone validation fails',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(const VerifyOTPEvent(otp: otp, phoneNumber: 123456)),
        expect: () => <AuthState>[
          const AuthVerifyingOTP(),
          const AuthOTPVerificationFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when MyEvent is added.',
          build: () {
            when(() => verifyOTP(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc
              .add(const VerifyOTPEvent(otp: otp, phoneNumber: phoneNumber)),
          expect: () => <AuthState>[
                const AuthVerifyingOTP(),
                AuthOTPVerificationFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => verifyOTP(const CustomVerificationParam(
                phoneNumber: phoneNumber, otp: otp))).called(1);
            verifyNoMoreInteractions(verifyOTP);
          });
    });
    group("[Login] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyingOTP(), const AuthOTPVerified()] when MyEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => Right(UserModel.empty()));
            return authBloc;
          },
          act: (bloc) => bloc.add(LoginEvent(
              phoneNumber: phoneNumber,
              countryCode: countryCode,
              name: name,
              image: image)),
          expect: () =>
              <AuthState>[const AuthloggingIn(), const AuthloggedIn()],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumber,
                countryCode: countryCode,
                name: name,
                image: image))).called(1);
            verifyNoMoreInteractions(loginUser);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when country code validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(LoginEvent(
            phoneNumber: phoneNumber,
            countryCode: "",
            name: name,
            image: image)),
        expect: () => <AuthState>[
          const AuthloggingIn(),
          const AuthloginFailed("Country Code cannot be empty")
        ],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when phone validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(LoginEvent(
            phoneNumber: 123456,
            countryCode: countryCode,
            name: name,
            image: image)),
        expect: () => <AuthState>[
          const AuthloggingIn(),
          const AuthloginFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when MyEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(LoginEvent(
              phoneNumber: phoneNumber,
              countryCode: countryCode,
              name: name,
              image: image)),
          expect: () => <AuthState>[
                const AuthloggingIn(),
                AuthloginFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumber,
                countryCode: countryCode,
                name: name,
                image: image))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
    });
  });
}
