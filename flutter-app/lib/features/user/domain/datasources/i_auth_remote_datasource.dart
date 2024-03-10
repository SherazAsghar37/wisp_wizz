import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

abstract class IAuthRemoteDatasource {
  // ignore: unused_field
  final Dio _dio;
  IAuthRemoteDatasource({required Dio dio}) : _dio = dio;

  Future<UserModel> loginUser(
      {required String? name, required String phoneNumber, Uint8List? image});

  Future<UserModel?> getUser({
    required String phoneNumber,
  });
  Future<UserModel> updateUser(
      {required String? name, required String id, Uint8List? image});
  Future<bool> connectSocket();
}
