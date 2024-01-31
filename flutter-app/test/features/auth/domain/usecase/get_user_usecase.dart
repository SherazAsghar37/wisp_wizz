import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/get_user_usecase.dart';

import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late GetUser getUser;

  setUp(() {
    authRepository = MAuthRepository();
    getUser = GetUser(authRepository: authRepository);
  });

  const params = CustomGetUserParam(
    countryCode: "whatever.countryCode",
    phoneNumber: 123456789,
  );
  final UserModel user = UserModel.empty();

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.getUser(
            phoneNumber: any(named: "phoneNumber"),
            countryCode: any(named: "countryCode"),
          )).thenAnswer((invocation) async => Right(user));
      //Assert
      final response = await getUser(CustomGetUserParam(
          phoneNumber: params.phoneNumber, countryCode: params.countryCode));
      expect(response, Right<dynamic, UserModel>(user));
      verify(
        () => authRepository.getUser(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
