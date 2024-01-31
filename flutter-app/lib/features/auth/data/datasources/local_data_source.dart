import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class LocalDatasource {
  final SharedPreferences _sharedPreferences;
  LocalDatasource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

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

  UserModel? getCachedUserData() {
    try {
      String? userData = _sharedPreferences.getString(sUserDataKey);
      if (userData != null) {
        return UserModel.fromJson(userData);
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
}
