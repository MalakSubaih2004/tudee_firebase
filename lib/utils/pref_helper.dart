import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String _keyUserName = 'user_name';

  static Future<bool> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUserName, name);
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  static Future<bool> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
