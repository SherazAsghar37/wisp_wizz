import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wisp_wizz/features/auth/data/datasources/remote_data_source.dart';
import 'package:wisp_wizz/features/auth/data/repositories/auth_repository.dart';

class MRemoteDatasource extends Mock implements RemoteDatasource {}

void main() {
  late AuthRepository authRepository;
  late RemoteDatasource remoteDatasource;

  setUp(() {
    remoteDatasource = MRemoteDatasource();
    authRepository = AuthRepository(remoteDataSource: remoteDatasource);
  });
  group("[Auth reposiotry Implementation] - ", () {
    group("[Login User] - ", () {
      test(
          "It should call remoteDataSource.loginUser and return void by calling only once",
          () => {
                //Arrange
                when(() => remoteDatasource.loginUser(
                        name: any(named: "name"),
                        phoneNumber: any(named: "phoneNumber"),
                        countryCode: any(named: "countryCode")))
                    .thenAnswer((invocation) async => const Right(null))
              });
    });
  });
}
