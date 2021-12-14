import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<dynamic> getData({required String key}) async {
    return sharedPreferences.get(key);
  }

  static Future<dynamic> removeData({required String key}) async {
    return sharedPreferences.remove(key);
  }

  static Future<bool> saveData({required String key, required dynamic value}) {
    if (value is String) return sharedPreferences.setString(key, value);
    if (value is bool) return sharedPreferences.setBool(key, value);
    if (value is int) return sharedPreferences.setInt(key, value);
    return sharedPreferences.setDouble(key, value);
  }


}
