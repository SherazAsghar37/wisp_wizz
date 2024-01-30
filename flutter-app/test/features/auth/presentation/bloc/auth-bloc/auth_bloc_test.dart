import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../global/phone_auth_cradentials.mock.dart';

class MSendCode extends Mock implements SendCode {}

class MVerifyOTP extends Mock implements VerifyOTP {}

class MLoginUser extends Mock implements LoginUser {}

class MGetUser extends Mock implements GetUser {}

void main() {
  late SendCode sendCode;
  late VerifyOTP verifyOTP;
  late LoginUser loginUser;
  late AuthBloc authBloc;
  late GetUser getUser;
  late PhoneAuthCredential phoneAuthCredential;

  const String countryCode = "whatever.countryCode";
  const String phoneNumber = "123456890";
  const int phoneNumberInt = 123456890;
  const String verificationId = "123456890";
  const String otp = "123456";
  const String name = "whatever.name";
  String? image = "whatever.image";

  const customPhoneParam =
      CustomPhoneParam(phoneNumber: phoneNumber, countryCode: countryCode);
  const customVerificationParam =
      CustomVerificationParam(verificationId: verificationId, otp: otp);
  final customUserParam = CustomUserParam(
      countryCode: countryCode,
      name: name,
      phoneNumber: 1234567890,
      image: image);
  const customPhoneResponse =
      CustomPhoneResoponse(verificationId: verificationId);
  const customGetUserParam =
      CustomGetUserParam(phoneNumber: phoneNumberInt, countryCode: countryCode);
  const ApiFailure apiFailure =
      ApiFailure(message: "whatever.message", statusCode: 500);
  UserModel userModel = UserModel.empty();
  setUp(() {
    sendCode = MSendCode();
    verifyOTP = MVerifyOTP();
    loginUser = MLoginUser();
    getUser = MGetUser();
    authBloc = AuthBloc(
        loginUser: loginUser,
        sendCode: sendCode,
        verifyOTP: verifyOTP,
        getUser: getUser);
    phoneAuthCredential = MPhoneAuthCradential();

    registerFallbackValue(customPhoneParam);
    registerFallbackValue(customVerificationParam);
    registerFallbackValue(customUserParam);
    registerFallbackValue(customGetUserParam);
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
            when(() => sendCode(any())).thenAnswer(
                (invocation) async => const Right(customPhoneResponse));
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
          'emits >[AuthSendingCode(), AuthOTPVerified()] when MyEvent is added.',
          build: () {
            when(() => sendCode(any())).thenAnswer((invocation) async => Right(
                CustomPhoneResoponse(
                    verificationId: "",
                    phoneAuthCredential: phoneAuthCredential)));
            return authBloc;
          },
          act: (bloc) => bloc.add(const SendCodeEvent(
              countryCode: countryCode, phoneNumber: phoneNumber)),
          expect: () =>
              <AuthState>[const AuthSendingCode(), const AuthOTPVerified()],
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
            countryCode: countryCode, phoneNumber: "123456")),
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
                .thenAnswer((invocation) async => Right(phoneAuthCredential));
            return authBloc;
          },
          act: (bloc) => bloc.add(const VerifyOTPEvent(otp: otp)),
          expect: () =>
              <AuthState>[const AuthVerifyingOTP(), const AuthOTPVerified()],
          verify: (bloc) {
            verify(() => verifyOTP(const CustomVerificationParam(
                verificationId: "", otp: otp))).called(1);
            verifyNoMoreInteractions(verifyOTP);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when otp validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const VerifyOTPEvent(otp: "1234")),
        expect: () => <AuthState>[
          const AuthVerifyingOTP(),
          const AuthOTPVerificationFailed("Invalid OTP")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when MyEvent is added.',
          build: () {
            when(() => verifyOTP(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const VerifyOTPEvent(
                otp: otp,
              )),
          expect: () => <AuthState>[
                const AuthVerifyingOTP(),
                AuthOTPVerificationFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => verifyOTP(const CustomVerificationParam(
                verificationId: "", otp: otp))).called(1);
            verifyNoMoreInteractions(verifyOTP);
          });
    });
    group("[GetUser] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyi<AuthState>[const AuthGettingUser(),AuthUserFound(user: UserModel.empty())], when MyEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
              phoneNumber: phoneNumber, countryCode: countryCode)),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthUserFound(user: userModel)
              ],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                phoneNumber: phoneNumberInt,
                countryCode: countryCode))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyi<AuthState>[const AuthGettingUser(),AuthUserFound(user: UserModel.empty())], when MyEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
              phoneNumber: phoneNumber, countryCode: countryCode)),
          expect: () =>
              <AuthState>[const AuthGettingUser(), const AuthUserNotFound()],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                phoneNumber: phoneNumberInt,
                countryCode: countryCode))).called(1);
            verifyNoMoreInteractions(getUser);
          });

      blocTest<AuthBloc, AuthState>(
          'emits <AuthState>[const AuthGettingUser(),AuthFailedToGetUser(apiFailure.message)] when MyEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
              phoneNumber: phoneNumber, countryCode: countryCode)),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthFailedToGetUser(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                phoneNumber: phoneNumberInt,
                countryCode: countryCode))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
    });
    group("[Login] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyingOTP(), const AuthOTPVerified()] when MyEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            return authBloc;
          },
          act: (bloc) => bloc.add(LoginEvent(
              phoneNumber: phoneNumber,
              countryCode: countryCode,
              name: name,
              image: image)),
          expect: () =>
              <AuthState>[const AuthloggingIn(), AuthloggedIn(user: userModel)],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumberInt,
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
            phoneNumber: "123456",
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
                phoneNumber: phoneNumberInt,
                countryCode: countryCode,
                name: name,
                image: image))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
    });
  });
}
