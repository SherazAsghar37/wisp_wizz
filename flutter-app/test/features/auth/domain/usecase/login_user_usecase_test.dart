import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';

import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late LoginUser loginUser;

  setUp(() {
    authRepository = MAuthRepository();
    loginUser = LoginUser(authRepository: authRepository);
  });

  const params = CustomUserParam(
      countryCode: "whatever.countryCode",
      name: "whatever.name",
      phoneNumber: 123456789,
      image: "whatever.image");
  final UserModel user = UserModel.empty();

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.loginUser(
              name: any(named: "name"),
              phoneNumber: any(named: "phoneNumber"),
              countryCode: any(named: "countryCode"),
              image: any(named: "image")))
          .thenAnswer((invocation) async => Right(user));
      //Assert
      final response = await loginUser(params);
      expect(response, Right<dynamic, UserModel>(user));
      verify(
        () => authRepository.loginUser(
            name: params.name,
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            image: params.image),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
