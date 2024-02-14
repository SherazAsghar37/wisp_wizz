import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_cached_user.dart';

import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late GetCachedUser getCachedUser;
  final UserModel user = UserModel.empty();
  setUp(() {
    authRepository = MAuthRepository();
    getCachedUser = GetCachedUser(authRepository: authRepository);
    registerFallbackValue(user);
  });

  group("[Auth Repository] - ", () {
    test(
        "It should call auth repository.getCachedUser and return user by calling only once",
        () async {
      //Arrange
      when(() => authRepository.getCachedUser())
          .thenAnswer((invocation) => Right(user));
      //Assert
      final response = getCachedUser();
      expect(response, Right<dynamic, UserModel>(user));
      verify(
        () => authRepository.getCachedUser(),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
    test(
        "It should call auth repository.getCachedUser and return null by calling only once",
        () async {
      //Arrange
      when(() => authRepository.getCachedUser())
          .thenAnswer((invocation) => const Right(null));
      //Assert
      final response = getCachedUser();
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.getCachedUser(),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
