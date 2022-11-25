import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

Future<bool> saveString(String key, String value) async {
  final pref = await sharedPreferences;
  return await pref.setString(key, value);
}

Future<String?> getString(String key) async {
  final pref = await sharedPreferences;
  return pref.getString(key);
}
