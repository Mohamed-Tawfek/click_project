import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? sharedPreferences;
  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static String? get(key) {
    return sharedPreferences!.getString(key);
  }

  static Future<bool> set(key,String value) async {
    return await sharedPreferences!.setString(key, value);
  }

  static Future<bool> deleteAllData() async {
    return await sharedPreferences!.clear();
  }
}
