import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static SharedPreferences? sharedPreferences;

  SharedPreferencesConfig._internal();

  Future<void> getInstance() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
