import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/init_application_usecase.dart';
import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late InitApplication initApplication;

  setUp(() {
    authRepository = MAuthRepository();
    initApplication = InitApplication(authRepository: authRepository);
  });

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.initApplication())
          .thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await initApplication();
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.initApplication(),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
