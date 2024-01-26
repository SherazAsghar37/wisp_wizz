import 'dart:convert';
import 'dart:io';
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
      File? image}) async {
    try {
      final String url = _dio.options.baseUrl + loginUrl;
      final MapData data = {
        'image': image != null
            ? await MultipartFile.fromFile(
                image.path,
                filename: imageFileName,
              )
            : null,
        "name": name,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode
      };

      final response = await _dio.post(
        url,
        data: FormData.fromMap(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
        DebugHelper.printWarning(userData["user"].runtimeType.toString());
        return UserModel.fromMap(userData["user"]);
      } else {
        throw DioException(
          requestOptions: RequestOptions(),
          message: response.data["message"],
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (dioException) {
      throw ApiException(
          message: dioException.message.toString(), statusCode: 500);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
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
      Dio dio = Dio();

      final response = await dio.post(
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
        throw DioException(
          requestOptions: RequestOptions(),
          message: response.data["message"],
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (dioException) {
      throw ApiException(
          message: dioException.message.toString(), statusCode: 500);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
