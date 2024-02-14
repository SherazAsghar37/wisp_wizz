import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/cache_user_usecase.dart';

import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late CacheUser cacheUser;
  final UserModel user = UserModel.empty();
  setUp(() {
    authRepository = MAuthRepository();
    cacheUser = CacheUser(authRepository: authRepository);
    registerFallbackValue(user);
  });

  group("[Auth Repository] - ", () {
    test("It should call auth repository.cacheUser and should call only once",
        () async {
      //Arrange
      when(() => authRepository.cacheUser(
            any(),
          )).thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await cacheUser(user);
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.cacheUser(user),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
