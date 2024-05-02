import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager<T> {
  final String key;

  SharedPrefManager({required this.key});
  static late SharedPreferences _preferences;
  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<bool> clear() async {
    return await _preferences.clear();
  }

  bool isKeyExist() {
    return _preferences.containsKey(key);
  }

  Future<bool> saveData({required T data}) async {
    try {
      if (data is String) {
        return await _preferences.setString(key, data);
      } else if (data is int) {
        return await _preferences.setInt(key, data);
      } else if (data is double) {
        return await _preferences.setDouble(key, data);
      } else if (data is bool) {
        return await _preferences.setBool(key, data);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  T? getData() {
    bool isKeyNotExist = !_preferences.containsKey(key);

    if (isKeyNotExist) return null;

    if (T == String) {
      return _preferences.getString(key) as T;
    } else if (T == int) {
      return _preferences.getInt(key) as T;
    } else if (T == double) {
      return _preferences.getDouble(key) as T;
    } else if (T == bool) {
      return _preferences.getBool(key) as T;
    } else {
      throw UnsupportedError("Unsupported type: ${T.toString()}");
    }
  }
}
