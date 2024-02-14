import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/logout_usecase.dart';
import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late LogoutUser logoutUser;

  setUp(() {
    authRepository = MAuthRepository();
    logoutUser = LogoutUser(authRepository: authRepository);
  });

  group("[Auth Repository] - ", () {
    test("It should call auth repository.logoutUser and should call only once",
        () async {
      //Arrange
      when(() => authRepository.logout())
          .thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await logoutUser();
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.logout(),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
