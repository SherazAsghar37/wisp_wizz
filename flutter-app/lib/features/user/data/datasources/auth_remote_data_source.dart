import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/datasources/socket_manager_wrapper.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/datasources/i_auth_remote_datasource.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final Dio _dio;
  final WebSocketManagerWrapper _webSocketManagerWrapper;
  AuthRemoteDatasource({
    required Dio dio,
    required WebSocketManagerWrapper webSocketManagerWrapper,
  })  : _dio = dio,
        _webSocketManagerWrapper = webSocketManagerWrapper;

  @override
  Future<UserModel> loginUser({
    required String? name,
    required String phoneNumber,
    Uint8List? image,
  }) async {
    try {
      // ByteData assetByteData = await rootBundle.load("images/profile.png");
      // Uint8List assetBytes = assetByteData.buffer.asUint8List();
      // image = image ?? assetBytes;
      final MapData data = {
        'image': image != null ? base64Encode(image) : null,
        "name": name,
        "phoneNumber": phoneNumber
      };

      final response = await _dio.post(
        loginUrl,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
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
      DebugHelper.printError("Dio Exception : ${dioException.message}");
      throw const ApiException(
          message: "Internal server error", statusCode: 500);
    } catch (e) {
      DebugHelper.printError("Exception: $e");
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }

  @override
  Future<UserModel?> getUser({
    required String phoneNumber,
  }) async {
    try {
      final MapData data = {
        "phoneNumber": phoneNumber,
      };

      final response = await _dio.post(
        getUserUrl,
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
      DebugHelper.printError("get user error:$e");
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }

  @override
  Future<UserModel> updateUser({
    required String? name,
    required String id,
    Uint8List? image,
  }) async {
    try {
      final MapData data = {
        'image': image != null ? base64Encode(image) : null,
        "name": name,
        "id": id
      };
      final String url = _dio.options.baseUrl + updateUserUrl;
      final response = await _dio.put(
        url,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
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
      DebugHelper.printError("Dio Exception : ${dioException.message}");
      throw const ApiException(
          message: "Internal server error", statusCode: 500);
    } catch (e) {
      DebugHelper.printError("Exception: $e");
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }

  @override
  void connectSocket(String userId) {
    try {
      return _webSocketManagerWrapper.initSocket(userId);
    } catch (e) {
      DebugHelper.printError("connectSocket $e");
      throw const WebSocketException("unable to connect to the server");
    }
  }

  @override
  void disconnectSocket() {
    try {
      return _webSocketManagerWrapper.disconnect();
    } catch (e) {
      DebugHelper.printError("connectSocket $e");
      throw const WebSocketException("unable to connect to the server");
    }
  }

  @override
  Future<bool> deleteUser({required String id}) async {
    try {
      final MapData data = {"id": id};
      final String url = _dio.options.baseUrl + deleteUserUrl;
      final response = await _dio.delete(
        url,
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        MapData userData = MapData.from(json.decode(response.data));
        return userData["status"];
      } else {
        throw ApiException(
          message: response.data["message"],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on ApiException {
      rethrow;
    } on DioException catch (dioException) {
      DebugHelper.printError("Dio Exception : ${dioException.message}");
      throw const ApiException(
          message: "Internal server error", statusCode: 500);
    } catch (e) {
      DebugHelper.printError("Exception: $e");
      throw const ApiException(
          message: "Something went wrong", statusCode: 500);
    }
  }
}
