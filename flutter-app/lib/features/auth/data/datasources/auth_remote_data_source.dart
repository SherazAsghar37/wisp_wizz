import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
import 'package:wisp_wizz/features/auth/domain/datasources/i_auth_remote_datasource.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<UserModel> loginUser(
      {required String? name,
      required String phoneNumber,
      Uint8List? image}) async {
    try {
      final String url = _dio.options.baseUrl + loginUrl;
      ByteData assetByteData = await rootBundle.load("images/profile.png");
      Uint8List assetBytes = assetByteData.buffer.asUint8List();
      image = image ?? assetBytes;
      final MapData data = {
        'image': base64Encode(image),
        "name": name,
        "phoneNumber": phoneNumber,
      };

      final response = await _dio.post(
        url,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
        DebugHelper.printWarning(userData["user"].toString());
        return UserModel.fromMap(userData["user"]);
      } else {
        throw ApiException(
          message: response.data["message"],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (dioException) {
      DebugHelper.printError(dioException.message.toString());
      throw const ApiException(
          message: "Internal server error", statusCode: 500);
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }

  @override
  Future<UserModel?> getUser({
    required String phoneNumber,
  }) async {
    try {
      final String url = _dio.options.baseUrl + getUserUrl;
      final MapData data = {
        "phoneNumber": phoneNumber,
      };

      final response = await _dio.post(
        url,
        data: data,
      );
      DebugHelper.printError(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
        if (userData["user"] == null) {
          return null;
        } else {
          return UserModel.fromMap(userData["user"]);
        }
      } else {
        throw ApiException(
            message: response.data["message"],
            statusCode: response.statusCode ?? 500);
      }
    } on ApiException {
      rethrow;
    } on DioException catch (dioException) {
      DebugHelper.printError(dioException.message.toString());
      throw const ApiException(
          message: "Internal server error", statusCode: 500);
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }
}
