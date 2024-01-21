import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
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
        return UserModel.fromMap(json.decode(response.data["user"]));
      } else {
        throw DioException(
          requestOptions: RequestOptions(),
          message: response.data["message"],
        );
      }
    } on DioException catch (dioException) {
      throw ApiException(
          message: dioException.message.toString(), statusCode: 500);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> sendCode(
      {required int phoneNumber, required String countryCode}) async {
    try {
      final response = await _dio.post(
        _dio.options.baseUrl + sendCodeUrl,
        data: {"phoneNumber": phoneNumber, "countryCode": countryCode},
      );
      // .timeout(const Duration(seconds: 10));
      print(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: RequestOptions(),
          message: response.data["message"],
        );
      }
    } on DioException catch (dioException) {
      throw ApiException(
          message: dioException.message.toString(), statusCode: 500);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<void> verifyOTP({required int phoneNumber, required int otp}) async {
    try {
      final response = await _dio.post(
        _dio.options.baseUrl + verifyOTPUrl,
        data: {"phoneNumber": phoneNumber, "otp": otp},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: RequestOptions(),
          message: response.data["message"],
        );
      }
    } on DioException catch (dioException) {
      throw ApiException(
          message: dioException.message.toString(), statusCode: 500);
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }
}
