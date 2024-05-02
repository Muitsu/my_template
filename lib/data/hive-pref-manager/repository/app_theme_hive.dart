import 'package:flutter/material.dart';
import 'package:my_template/data/hive-pref-manager/hive_box_manager.dart';

class AppThemeHive {
  //Variables
  static const String key = "app_theme";
  //MUST HAVE DATA TYPE <bool>
  static final themePref = HiveBoxPreference<bool>(key: key);
  //Functions
  static Future<void> setIsLightMode({required bool val}) async {
    await themePref.saveData(value: val);
  }

  static bool isLightTheme() => themePref.getData() ?? true;

  static ThemeMode getCurrentTheme() {
    final isLight = themePref.getData() ?? true;
    ThemeMode result = isLight ? ThemeMode.light : ThemeMode.dark;
    return result;
  }
}
