import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late SendCode sendCode;

  setUp(() {
    authRepository = MAuthRepository();
    sendCode = SendCode(authRepository: authRepository);
  });

  final params = CustomPhoneParam(
    countryCode: "whatever.countryCode",
    phoneNumber: 123456789,
  );

  group("[Auth Repository] - ", () {
    test("It should call auth repository.sendCode and should call only once",
        () async {
      //Arrange
      when(() => authRepository.sendCode(
            phoneNumber: any(named: "phoneNumber"),
            countryCode: any(named: "countryCode"),
          )).thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await sendCode(params);
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.sendCode(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
