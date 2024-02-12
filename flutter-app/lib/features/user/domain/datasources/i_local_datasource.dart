import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';

abstract class IAuthLocalDatasource {
  // ignore: unused_field
  final SharedPreferences _sharedPreferences;
  IAuthLocalDatasource({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  Future<void> cacheUserData(UserModel user);

  UserModel? getCachedUserData();
  Future<void> removeCachedUser();
}
