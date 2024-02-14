import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/user/data/datasources/auth_firebase_datasource.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/verify_otp_usecase.dart';

class MFirebaseAuth extends Mock implements FirebaseAuth {}

class MPhoneAuthCredential extends Mock implements PhoneAuthCredential {}

class MUserCradentials extends Mock implements UserCredential {}

class MPhoneAuthProviderWrapper extends Mock
    implements PhoneAuthProviderWrapper {}

void main() {
  late FirebaseAuth firebaseAuth;
  late AuthFirebaseDatasource firebaseAuthentication;
  late PhoneAuthCredential phoneAuthCredential;
  late MPhoneAuthProviderWrapper phoneAuthProviderWrapper;
  late MUserCradentials userCradentials;

  setUp(() {
    firebaseAuth = MFirebaseAuth();
    phoneAuthProviderWrapper = MPhoneAuthProviderWrapper();
    firebaseAuthentication = AuthFirebaseDatasource(
        auth: firebaseAuth, phoneAuthProviderWrapper: phoneAuthProviderWrapper);
    phoneAuthCredential = MPhoneAuthCredential();
    userCradentials = MUserCradentials();
    registerFallbackValue(phoneAuthCredential);
  });

  const otpParams = CustomVerificationParam(
    otp: "123456",
    verificationId: "123456789",
  );

  const customPhoneParam = CustomPhoneParam(
    phoneNumber: "123456789",
  );
  const int statusCode = 403;
  const int resendToken = 100;
  const String errorMessage = "whatever.error";

  group("[Auth FirebaseAuthentication] - ", () {
    group("[Send Code] - ", () {
      test("It should call verifyPhoneNumber and return CustomPhoneResoponse ",
          () async {
        //Arrange
        when(() => firebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: "phoneNumber"),
              verificationCompleted: any(named: "verificationCompleted"),
              verificationFailed: any(named: "verificationFailed"),
              codeSent: any(named: "codeSent"),
              codeAutoRetrievalTimeout: any(named: "codeAutoRetrievalTimeout"),
            )).thenAnswer((invocation) async {
          final verificationCompleted =
              invocation.namedArguments[#verificationCompleted]
                  as PhoneVerificationCompleted?;

          verificationCompleted?.call(phoneAuthCredential);
        });
        //Act
        final response = await firebaseAuthentication.sendCode(
          phoneNumber: customPhoneParam.phoneNumber,
        );
        //Assert
        expect(
            response,
            CustomPhoneResoponse(
                verificationId: "", phoneAuthCredential: phoneAuthCredential));
      });
      test("It should call verifyPhoneNumber and throw Api exception ",
          () async {
        //Arrange
        when(() => firebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: "phoneNumber"),
              verificationCompleted: any(named: "verificationCompleted"),
              verificationFailed: any(named: "verificationFailed"),
              codeSent: any(named: "codeSent"),
              codeAutoRetrievalTimeout: any(named: "codeAutoRetrievalTimeout"),
            )).thenAnswer((invocation) async {
          final verificationFailed = invocation
              .namedArguments[#verificationFailed] as PhoneVerificationFailed?;

          verificationFailed
              ?.call(FirebaseAuthException(code: "500", message: errorMessage));
        });
        //Act
        final response = firebaseAuthentication.sendCode(
          phoneNumber: "+9230111123123",
        );
        //Assert
        await expectLater(
            response,
            throwsA(const ApiException(
                message: "Failed to send code, please try again later",
                statusCode: statusCode)));
      });

      test(
          "It should call verifyPhoneNumber and return CustomPhoneResoponse with verificationId",
          () async {
        //Arrange
        when(() => firebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: "phoneNumber"),
              verificationCompleted: any(named: "verificationCompleted"),
              verificationFailed: any(named: "verificationFailed"),
              codeSent: any(named: "codeSent"),
              codeAutoRetrievalTimeout: any(named: "codeAutoRetrievalTimeout"),
            )).thenAnswer((invocation) async {
          final codeSent =
              invocation.namedArguments[#codeSent] as PhoneCodeSent?;

          codeSent?.call(otpParams.verificationId, resendToken);
        });
        //Act
        final response = await firebaseAuthentication.sendCode(
          phoneNumber: customPhoneParam.phoneNumber,
        );
        //Assert
        expect(
            response,
            CustomPhoneResoponse(
                verificationId: otpParams.verificationId,
                phoneAuthCredential: null));
      });
      test(
          "It should call verifyPhoneNumber and return CustomPhoneResoponse when PhoneCodeAutoRetrievalTimeout",
          () async {
        //Arrange
        when(() => firebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: "phoneNumber"),
              verificationCompleted: any(named: "verificationCompleted"),
              verificationFailed: any(named: "verificationFailed"),
              codeSent: any(named: "codeSent"),
              codeAutoRetrievalTimeout: any(named: "codeAutoRetrievalTimeout"),
            )).thenAnswer((invocation) async {
          final codeAutoRetrievalTimeout =
              invocation.namedArguments[#codeAutoRetrievalTimeout]
                  as PhoneCodeAutoRetrievalTimeout?;

          codeAutoRetrievalTimeout?.call(
            otpParams.verificationId,
          );
        });
        //Act
        final response = await firebaseAuthentication.sendCode(
          phoneNumber: customPhoneParam.phoneNumber,
        );
        //Assert
        expect(
            response,
            CustomPhoneResoponse(
                verificationId: otpParams.verificationId,
                phoneAuthCredential: null));
      });
    });
    group("[Verify OTP] - ", () {
      test("It should post verifyOTP and return phoneAuthCredential", () async {
        //Arrange
        when(() => phoneAuthProviderWrapper.credential(
              verificationId: otpParams.verificationId,
              smsCode: otpParams.otp,
            )).thenAnswer((invocation) => phoneAuthCredential);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((invocation) async => userCradentials);
        //Act
        final response = await firebaseAuthentication.verifyOTP(
          verificationId: otpParams.verificationId,
          otp: otpParams.otp,
        );
        //Assert
        expect(response, phoneAuthCredential);
      });
      test("It should post verifyOTP and return firebase", () async {
        //Arrange
        when(() => phoneAuthProviderWrapper.credential(
                  verificationId: otpParams.verificationId,
                  smsCode: otpParams.otp,
                ))
            .thenThrow((invocation) =>
                FirebaseAuthException(code: "500", message: errorMessage));
        //Act
        final response = firebaseAuthentication.verifyOTP(
          verificationId: otpParams.verificationId,
          otp: otpParams.otp,
        );
        //Assert
        expect(
            response,
            throwsA(const ApiException(
                message: "Invalid OTP", statusCode: statusCode)));
      });
    });
  });
}
