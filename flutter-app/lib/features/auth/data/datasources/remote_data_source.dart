import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class RemoteDatasource {
  final Dio _dio;
  RemoteDatasource({required Dio dio}) : _dio = dio;

  Future<UserModel> loginUser(
      {required String? name,
      required int phoneNumber,
      required String countryCode,
      String? image}) async {
    try {
      final String url = _dio.options.baseUrl + loginUrl;
      final MapData data = {
        'image': image,
        "name": name,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode
      };

      final response = await _dio.post(
        url,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
        DebugHelper.printWarning(userData.toString());
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

  Future<UserModel?> getUser({
    required int phoneNumber,
    required String countryCode,
  }) async {
    try {
      final String url = _dio.options.baseUrl + getUserUrl;
      final MapData data = {
        "phoneNumber": phoneNumber,
        "countryCode": countryCode
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
