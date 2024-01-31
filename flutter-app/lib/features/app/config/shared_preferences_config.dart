import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static SharedPreferences? sharedPreferences;

  SharedPreferencesConfig._internal();

  static Future<SharedPreferences> getInstance() async {
    return sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
