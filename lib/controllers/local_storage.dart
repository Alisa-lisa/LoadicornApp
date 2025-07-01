import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final SharedPreferencesAsync storage = SharedPreferencesAsync();
  // Private constructor to prevent external instantiation
  Storage._();

  // Static instance for easy access
  static final storageinstance = Storage._();
  static Future<void> setStr(String key, String value) async {
    await storage.setString(key, value);
  }

  static Future<String?> getStr(String key) async {
    return await storage.getString(key);
  }

  static Future<void> clean() async {
    await storage.clear();
  }
}
