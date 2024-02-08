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

  const params = CustomPhoneParam(
    phoneNumber: "123456789",
  );

  const String verificationId = "1234";
  const customPhoneResoponse =
      CustomPhoneResoponse(verificationId: verificationId);

  group("[Auth Repository] - ", () {
    test("It should call auth repository.sendCode and should call only once",
        () async {
      //Arrange
      when(() => authRepository.sendCode(
                phoneNumber: any(named: "phoneNumber"),
              ))
          .thenAnswer((invocation) async => const Right(customPhoneResoponse));
      //Assert
      final response = await sendCode(params);
      expect(response,
          const Right<dynamic, CustomPhoneResoponse>(customPhoneResoponse));
      verify(
        () => authRepository.sendCode(
          phoneNumber: params.phoneNumber,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
