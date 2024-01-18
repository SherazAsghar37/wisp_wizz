import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/domain/repository/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import '../repository/auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late VerifyOTP verifyOTP;

  setUp(() {
    authRepository = MAuthRepository();
    verifyOTP = VerifyOTP(authRepository: authRepository);
  });

  final params = CustomVerificationParam(
    phoneNumber: 123456789,
    otp: 123456789,
  );

  group("[Auth Repository] - ", () {
    test("It should call auth repository.verifyotp and should call only once",
        () async {
      //Arrange
      when(() => authRepository.verifyOTP(
            phoneNumber: any(named: "phoneNumber"),
            otp: any(named: "otp"),
          )).thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await verifyOTP(params);
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.verifyOTP(
          phoneNumber: params.phoneNumber,
          otp: params.otp,
        ),
      );
      verifyNoMoreInteractions(authRepository);
    });
  });
}
