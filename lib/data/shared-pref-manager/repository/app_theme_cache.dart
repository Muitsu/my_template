import 'package:flutter/material.dart';
import 'package:my_template/data/shared-pref-manager/shared_pref_manager.dart';

class AppThemeCache {
  static const _keyAppTheme = 'isLightMode';
  //MUST HAVE DATA TYPE <bool>
  static final themeManager = SharedPrefManager<bool>(key: _keyAppTheme);
  /*APP THEME*/
  static bool isLightTheme() => themeManager.getData() ?? true;

  static Future<bool> setIsLightMode({required bool val}) async {
    bool result = await themeManager.saveData(data: val);
    return result;
  }

  static Future<ThemeMode> setThemeMode({required ThemeMode theme}) async {
    bool data = theme == ThemeMode.light;
    ThemeMode result = data ? ThemeMode.light : ThemeMode.dark;
    bool response = await themeManager.saveData(data: data);
    result = response ? theme : result;
    return result;
  }

  static ThemeMode getCurrTheme() {
    final response = themeManager.getData() ?? true;
    ThemeMode result = response ? ThemeMode.light : ThemeMode.dark;
    return result;
  }
}
