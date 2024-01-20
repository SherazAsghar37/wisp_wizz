import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MSendCode extends Mock implements SendCode {}

class MVerifyOTP extends Mock implements VerifyOTP {}

class MLoginUser extends Mock implements LoginUser {}

void main() {
  late SendCode sendCode;
  late VerifyOTP verifyOTP;
  late LoginUser loginUser;
  late AuthBloc authBloc;

  const String countryCode = "whatever.countryCode";
  const int phoneNumber = 1234567890;

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
        act: (bloc) => bloc.add(const SendCodeEvent(
            countryCode: countryCode, phoneNumber: 1234567)),
        expect: () => <AuthState>[
          const AuthSendingCode(),
          const AuthCodeSentFailed("Invalied phone number")
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
  });
}
