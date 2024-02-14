import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';
import 'package:wisp_wizz/features/user/domain/usecase/update_user_usecase.dart';
import '../../../../app/temp_path.dart';
import '../repository/i_auth_repository_test.dart';

void main() {
  late IAuthRepository authRepository;
  late UpdateUser updateUser;

  setUp(() {
    authRepository = MAuthRepository();
    updateUser = UpdateUser(authRepository: authRepository);
  });

  final params = UpdateUserParam(
      name: "whatever.name",
      id: "asf+9asf21asdsaf23456789",
      image: tempFile.readAsBytesSync());
  final UserModel user = UserModel.empty();

  group("[Auth Repository] - ", () {
    test("It should call auth repository and should call only once", () async {
      //Arrange
      when(() => authRepository.updateUser(
              name: any(named: "name"),
              id: any(named: "id"),
              image: any(named: "image")))
          .thenAnswer((invocation) async => Right(user));
      //Assert
      final response = await updateUser(params);
      expect(response, Right<dynamic, UserModel>(user));
      verify(
        () => authRepository.updateUser(
            name: params.name, id: params.id, image: params.image),
      ).called(1);
      verifyNoMoreInteractions(authRepository);
    });
  });
}
