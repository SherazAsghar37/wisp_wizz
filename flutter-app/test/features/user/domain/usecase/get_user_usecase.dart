import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_user_usecase.dart';

import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late GetUser getUser;

  setUp(() {
    authRepository = MAuthRepository();
    getUser = GetUser(authRepository: authRepository);
  });

  const params = CustomGetUserParam(
    phoneNumber: "+92123456789",
  );
  final UserModel user = UserModel.empty();

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.getUser(
            phoneNumber: any(named: "phoneNumber"),
          )).thenAnswer((invocation) async => Right(user));
      //Assert
      final response = await getUser(CustomGetUserParam(
        phoneNumber: params.phoneNumber,
      ));
      expect(response, Right<dynamic, UserModel>(user));
      verify(
        () => authRepository.getUser(
          phoneNumber: params.phoneNumber,
        ),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
