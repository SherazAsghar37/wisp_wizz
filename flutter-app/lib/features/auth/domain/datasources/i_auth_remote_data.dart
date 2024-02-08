import 'package:dio/dio.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

abstract class IAuthRemoteDatasource {
  // ignore: unused_field
  final Dio _dio;
  IAuthRemoteDatasource({required Dio dio}) : _dio = dio;

  Future<UserModel> loginUser(
      {required String? name, required String phoneNumber, String? image});

  Future<UserModel?> getUser({
    required String phoneNumber,
  });
}
