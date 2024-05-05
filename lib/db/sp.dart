import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? _preferences;
  static const String keyUserType = 'userType';
  static const String keyIsLoggedIn = 'isLoggedIn';

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type) async {
    return await _preferences!.setString(keyUserType, type);
  }

  static Future<String?> getUserType() async =>
      await _preferences!.getString(keyUserType) ?? "";

  static Future<void> clearUserData() async {
    if (_preferences != null) {
      await _preferences!.remove(keyUserType);
      await _preferences!.remove(keyIsLoggedIn);
    }
  }
}
