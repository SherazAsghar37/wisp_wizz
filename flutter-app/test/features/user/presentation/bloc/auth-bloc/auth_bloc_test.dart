import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/failure.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/usecase/cache_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_cached_user.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/logout_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/update_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/user/presentation/bloc/auth-bloc/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../../app/temp_path.dart';
import '../../../global/phone_auth_cradentials.mock.dart';

class MSendCode extends Mock implements SendCode {}

class MVerifyOTP extends Mock implements VerifyOTP {}

class MLoginUser extends Mock implements LoginUser {}

class MGetUser extends Mock implements GetUser {}

class MGetCachedUser extends Mock implements GetCachedUser {}

class MLogoutUser extends Mock implements LogoutUser {}

class MUpdateUser extends Mock implements UpdateUser {}

class MCacheUser extends Mock implements CacheUser {}

void main() {
  late SendCode sendCode;
  late VerifyOTP verifyOTP;
  late LoginUser loginUser;
  late AuthBloc authBloc;
  late GetUser getUser;
  late GetCachedUser getCachedUser;
  late LogoutUser logoutUser;
  late UpdateUser updateUser;
  late CacheUser cacheUser;

  late PhoneAuthCredential phoneAuthCredential;
  const String phoneNumber = "+92123456890";
  const String verificationId = "123456890";
  const String id = "asdfa+9123asf2123assf456890";
  const String otp = "123456";
  const String name = "whatever.name";
  Uint8List image = tempFile.readAsBytesSync();

  const customPhoneParam = CustomPhoneParam(
    phoneNumber: phoneNumber,
  );
  const customVerificationParam =
      CustomVerificationParam(verificationId: verificationId, otp: otp);
  final customUserParam = CustomUserParam(
      name: "whatever.name",
      phoneNumber: "+92123456789",
      image: tempFile.readAsBytesSync());
  const customPhoneResponse =
      CustomPhoneResoponse(verificationId: verificationId);
  const customGetUserParam = CustomGetUserParam(
    phoneNumber: phoneNumber,
  );
  const ApiFailure apiFailure =
      ApiFailure(message: "whatever.message", statusCode: 500);
  const CacheFailure cacheFailure = CacheFailure(
    message: "whatever.message",
  );

  final updateUserParam = UpdateUserParam(
      name: "whatever.name",
      id: "+sdg9sdg21234sdg5sdg6789",
      image: tempFile.readAsBytesSync());

  UserModel userModel = UserModel.empty();

  setUp(() {
    sendCode = MSendCode();
    verifyOTP = MVerifyOTP();
    loginUser = MLoginUser();
    getUser = MGetUser();
    getCachedUser = MGetCachedUser();
    logoutUser = MLogoutUser();
    updateUser = MUpdateUser();
    cacheUser = MCacheUser();

    authBloc = AuthBloc(
        loginUser: loginUser,
        sendCode: sendCode,
        verifyOTP: verifyOTP,
        getUser: getUser,
        getCachedUser: getCachedUser,
        logoutUser: logoutUser,
        updateUser: updateUser,
        cacheUser: cacheUser);
    phoneAuthCredential = MPhoneAuthCradential();

    registerFallbackValue(customPhoneParam);
    registerFallbackValue(customVerificationParam);
    registerFallbackValue(customUserParam);
    registerFallbackValue(customGetUserParam);
    registerFallbackValue(userModel);
    registerFallbackValue(updateUserParam);
  });
  tearDown(() => authBloc.close());

  group("[Auth Bloc] - ", () {
    test("initial state should be", () {
      expect(authBloc.state, equals(const AuthLoggedOut()));
    });
    group("[Send code] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[AuthSendingCode(), AuthCodeSent()] when SendCodeEvent is added.',
          build: () {
            when(() => sendCode(any())).thenAnswer(
                (invocation) async => const Right(customPhoneResponse));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(const SendCodeEvent(phoneNumber: phoneNumber)),
          expect: () =>
              <AuthState>[const AuthSendingCode(), const AuthCodeSent()],
          verify: (bloc) {
            verify(() => sendCode(const CustomPhoneParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(sendCode);
          });
      blocTest<AuthBloc, AuthState>(
          'emits >[AuthSendingCode(), AuthOTPVerified()] when SendCodeEvent is added.',
          build: () {
            when(() => sendCode(any())).thenAnswer((invocation) async => Right(
                CustomPhoneResoponse(
                    verificationId: "",
                    phoneAuthCredential: phoneAuthCredential)));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(const SendCodeEvent(phoneNumber: phoneNumber)),
          expect: () =>
              <AuthState>[const AuthSendingCode(), const AuthOTPVerified()],
          verify: (bloc) {
            verify(() => sendCode(const CustomPhoneParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(sendCode);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthSendingCode(),AuthCodeSentFailed()] when countrycode validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const SendCodeEvent(phoneNumber: "32214")),
        expect: () => <AuthState>[
          const AuthSendingCode(),
          const AuthCodeSentFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [AuthSendingCode(),AuthCodeSentFailed()] when phone validation fails',
        build: () => authBloc,
        act: (bloc) => bloc.add(const SendCodeEvent(phoneNumber: "+9211")),
        expect: () => <AuthState>[
          const AuthSendingCode(),
          const AuthCodeSentFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthSendingCode(),AuthCodeSentFailed()] when SendCodeEvent is added.',
          build: () {
            when(() => sendCode(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(const SendCodeEvent(phoneNumber: phoneNumber)),
          expect: () => <AuthState>[
                const AuthSendingCode(),
                AuthCodeSentFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => sendCode(const CustomPhoneParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(sendCode);
          });
    });
    group("[Verify Otp] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyingOTP(), const AuthOTPVerified()] when VerifyOTPEvent is added.',
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
          'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when VerifyOTPEvent is added.',
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
          'emits <AuthState>[AuthGettingUser(),AuthUserFound(user: userModel)], when GetUserEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
                phoneNumber: phoneNumber,
              )),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthUserFound(user: userModel)
              ],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
      blocTest<AuthBloc, AuthState>(
          'emits  <AuthState>[const AuthGettingUser(), const AuthUserNotFound()], when GetUserEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
                phoneNumber: phoneNumber,
              )),
          expect: () =>
              <AuthState>[const AuthGettingUser(), const AuthUserNotFound()],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(getUser);
          });

      blocTest<AuthBloc, AuthState>(
          'emits <AuthState>[const AuthGettingUser(), AuthFailedToGetUser(apiFailure.message)], when GetUserEvent is added.',
          build: () {
            when(() => getUser(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetUserEvent(
                phoneNumber: phoneNumber,
              )),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthFailedToGetUser(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => getUser(const CustomGetUserParam(
                  phoneNumber: phoneNumber,
                ))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
    });
    group("[Login] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits >[const AuthVerifyingOTP(), const AuthOTPVerified()] when LoginEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            when(() => cacheUser(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(
              LoginEvent(phoneNumber: phoneNumber, name: name, image: image)),
          expect: () =>
              <AuthState>[const AuthloggingIn(), AuthloggedIn(user: userModel)],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumber, name: name, image: image))).called(1);
            verify(() => cacheUser(userModel)).called(1);
            verifyNoMoreInteractions(loginUser);
          });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when country code validation fails',
        build: () => authBloc,
        act: (bloc) => bloc
            .add(LoginEvent(phoneNumber: "123123", name: name, image: image)),
        expect: () => <AuthState>[
          const AuthloggingIn(),
          const AuthloginFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
        'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when phone validation fails',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(LoginEvent(phoneNumber: "+921", name: name, image: image)),
        expect: () => <AuthState>[
          const AuthloggingIn(),
          const AuthloginFailed("Invalid phone number")
        ],
      );
      blocTest<AuthBloc, AuthState>(
          'emits [AuthVerifyingOTP(),AuthOTPVerificationFailed()] when LoginEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(
              LoginEvent(phoneNumber: phoneNumber, name: name, image: image)),
          expect: () => <AuthState>[
                const AuthloggingIn(),
                AuthloginFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumber, name: name, image: image))).called(1);
            verifyNoMoreInteractions(loginUser);
          });
      blocTest<AuthBloc, AuthState>(
          'emits [const AuthloggingIn(), AuthloginFailed(cacheFailure.message)] when LoginEvent is added.',
          build: () {
            when(() => loginUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            when(() => cacheUser(any()))
                .thenAnswer((invocation) async => const Left(cacheFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(
              LoginEvent(phoneNumber: phoneNumber, name: name, image: image)),
          expect: () => <AuthState>[
                const AuthloggingIn(),
                AuthloginFailed(cacheFailure.message)
              ],
          verify: (bloc) {
            verify(() => loginUser(CustomUserParam(
                phoneNumber: phoneNumber, name: name, image: image))).called(1);
            verify(() => cacheUser(userModel)).called(1);
            verifyNoMoreInteractions(loginUser);
          });
    });
    group("[Get Cached user] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits <AuthState>[const AuthGettingUser(),AuthloggedIn(user: userModel)], when GetCachedUserEvent is added.',
          build: () {
            when(() => getCachedUser())
                .thenAnswer((invocation) => Right(userModel));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetCachedUserEvent()),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthloggedIn(user: userModel)
              ],
          verify: (bloc) {
            verify(() => getCachedUser()).called(1);
            verifyNoMoreInteractions(getCachedUser);
          });
      blocTest<AuthBloc, AuthState>(
          'emits<AuthState>[const AuthGettingUser(), const AuthLoggedOut()], when GetCachedUserEvent is added.',
          build: () {
            when(() => getCachedUser())
                .thenAnswer((invocation) => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetCachedUserEvent()),
          expect: () =>
              <AuthState>[const AuthGettingUser(), const AuthLoggedOut()],
          verify: (bloc) {
            verify(() => getCachedUser()).called(1);
            verifyNoMoreInteractions(getCachedUser);
          });

      blocTest<AuthBloc, AuthState>(
          'emits <AuthState>[const AuthGettingUser(),AuthFailedToGetUser(apiFailure.message)] when GetCachedUserEvent is added.',
          build: () {
            when(() => getCachedUser())
                .thenAnswer((invocation) => const Left(cacheFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const GetCachedUserEvent()),
          expect: () => <AuthState>[
                const AuthGettingUser(),
                AuthFailedToGetUser(cacheFailure.message)
              ],
          verify: (bloc) {
            verify(() => getCachedUser()).called(1);
            verifyNoMoreInteractions(getCachedUser);
          });
    });
    group("[Logout user] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits<AuthState>[AuthLoggingout(), AuthLoggedOut()], when LogoutEvent is added.',
          build: () {
            when(() => logoutUser())
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) => bloc.add(const LogoutEvent()),
          expect: () => const <AuthState>[AuthLoggingout(), AuthLoggedOut()],
          verify: (bloc) {
            verify(() => logoutUser()).called(1);
            verifyNoMoreInteractions(logoutUser);
          });

      blocTest<AuthBloc, AuthState>(
          'emits <AuthState>[const AuthGettingUser(),AuthFailedToGetUser(apiFailure.message)] when MyEvent is added.',
          build: () {
            when(() => logoutUser())
                .thenAnswer((invocation) async => const Left(cacheFailure));
            return authBloc;
          },
          act: (bloc) => bloc.add(const LogoutEvent()),
          expect: () => <AuthState>[
                const AuthLoggingout(),
                AuthFailedToLogout(cacheFailure.message)
              ],
          verify: (bloc) {
            verify(() => logoutUser()).called(1);
            verifyNoMoreInteractions(logoutUser);
          });
    });
    group("[Update User] - ", () {
      blocTest<AuthBloc, AuthState>(
          'emits [const AuthUpdatingUser(),AuthUserUpdated(user: userModel)], when updateUser is added.',
          build: () {
            when(() => updateUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            when(() => cacheUser(any()))
                .thenAnswer((invocation) async => const Right(null));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(UpdateUserEvent(id: id, name: name, image: image)),
          expect: () => <AuthState>[
                const AuthUpdatingUser(),
                AuthloggedIn(user: userModel)
              ],
          verify: (bloc) {
            verify(() => updateUser(
                UpdateUserParam(id: id, name: name, image: image))).called(1);
            verify(() => cacheUser(userModel)).called(1);
            verifyNoMoreInteractions(updateUser);
          });

      blocTest<AuthBloc, AuthState>(
        'emits[const AuthUpdatingUser(), const AuthloginFailed("Invalid ID") ], when id is empty',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(UpdateUserEvent(id: "", name: name, image: image)),
        expect: () => <AuthState>[
          const AuthUpdatingUser(),
          const AuthloginFailed("Invalid ID")
        ],
      );

      blocTest<AuthBloc, AuthState>(
          'emits [const AuthUpdatingUser(), AuthloginFailed(apiFailure.message)], when UpdateUserEvent is added.',
          build: () {
            when(() => updateUser(any()))
                .thenAnswer((invocation) async => const Left(apiFailure));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(UpdateUserEvent(id: id, name: name, image: image)),
          expect: () => <AuthState>[
                const AuthUpdatingUser(),
                AuthloginFailed(apiFailure.message)
              ],
          verify: (bloc) {
            verify(() => updateUser(
                UpdateUserParam(id: id, name: name, image: image))).called(1);
            verifyNoMoreInteractions(updateUser);
          });
      blocTest<AuthBloc, AuthState>(
          'emits [  const AuthloggingIn(), AuthloginFailed(cacheFailure.message)], when UpdateUserEvent is added.',
          build: () {
            when(() => updateUser(any()))
                .thenAnswer((invocation) async => Right(userModel));
            when(() => cacheUser(any()))
                .thenAnswer((invocation) async => const Left(cacheFailure));
            return authBloc;
          },
          act: (bloc) =>
              bloc.add(UpdateUserEvent(id: id, name: name, image: image)),
          expect: () => <AuthState>[
                const AuthUpdatingUser(),
                AuthloginFailed(cacheFailure.message)
              ],
          verify: (bloc) {
            verify(() => updateUser(
                UpdateUserParam(id: id, name: name, image: image))).called(1);
            verify(() => cacheUser(userModel)).called(1);
            verifyNoMoreInteractions(updateUser);
          });
    });
  });
}
