import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import '../../global/phone_auth_cradentials.mock.dart';
import '../repository/i_auth_repository_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  late IAuthRepository authRepository;
  late VerifyOTP verifyOTP;
  late PhoneAuthCredential phoneAuthCredential;

  setUp(() {
    authRepository = MAuthRepository();
    verifyOTP = VerifyOTP(authRepository: authRepository);
    phoneAuthCredential = MPhoneAuthCradential();
  });

  const params = CustomVerificationParam(
    verificationId: "123456789",
    otp: "123456",
  );

  group("[Auth Repository] - ", () {
    test("It should call auth repository.verifyotp and should call only once",
        () async {
      //Arrange
      when(() => authRepository.verifyOTP(
            verificationId: any(named: "verificationId"),
            otp: any(named: "otp"),
          )).thenAnswer((invocation) async => Right(phoneAuthCredential));
      //Assert
      final response = await verifyOTP(params);
      expect(
          response, Right<dynamic, PhoneAuthCredential>(phoneAuthCredential));
      verify(
        () => authRepository.verifyOTP(
          verificationId: params.verificationId,
          otp: params.otp,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
