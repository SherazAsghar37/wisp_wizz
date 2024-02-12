import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/datasources/i_local_datasource.dart';

class AuthLocalDatasource implements IAuthLocalDatasource {
  final SharedPreferences _sharedPreferences;
  AuthLocalDatasource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      final res = await _sharedPreferences.setString(
          sUserDataKey, json.encode(user.toMap()));

      if (!res) {
        throw const CacheException(message: "Failed to cache user data");
      }
    } on CacheException {
      rethrow;
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const CacheException(
        message: "Something went wrong",
      );
    }
  }

  @override
  UserModel? getCachedUserData() {
    try {
      String? userData = _sharedPreferences.getString(sUserDataKey);

      if (userData != null) {
        UserModel user = UserModel.fromJson(userData);

        return user;
      } else {
        return null;
      }
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const CacheException(
        message: "Something went wrong",
      );
    }
  }

  @override
  Future<void> removeCachedUser() async {
    try {
      bool? userData = await _sharedPreferences.remove(sUserDataKey);
      if (!userData) {
        throw const CacheException(
            message: "Failed to delete cached user data");
      }
    } on CacheException {
      rethrow;
    } catch (e) {
      DebugHelper.printError(e.toString());
      throw const CacheException(
        message: "Something went wrong",
      );
    }
  }
}
