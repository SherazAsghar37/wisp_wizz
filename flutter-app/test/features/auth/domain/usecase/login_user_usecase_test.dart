import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/domain/repository/auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';

import '../repository/auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late LoginUser loginUser;

  setUp(() {
    authRepository = MAuthRepository();
    loginUser = LoginUser(authRepository: authRepository);
  });

  final params = CustomUserParam(
      countryCode: "whatever.countryCode",
      name: "whatever.name",
      phoneNumber: 123456789,
      image: File("whatever.file"));

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.loginUser(
              name: any(named: "name"),
              phoneNumber: any(named: "phoneNumber"),
              countryCode: any(named: "countryCode"),
              image: any(named: "image")))
          .thenAnswer((invocation) async => const Right(null));
      //Assert
      final response = await loginUser(params);
      expect(response, const Right<dynamic, void>(null));
      verify(
        () => authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image),
      );
      verifyNoMoreInteractions(authRepository);
    });
  });
}
