import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_export.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit() : super(ThemeMode.light);
  //Shared preference
  // ThemeMode themeMode = AppThemeCache.isLightTheme()
  //     ? ThemeMode.light
  //     : ThemeMode.dark;
  // bool get isDarkMode => themeMode == ThemeMode.dark;
  // void toggleTheme(bool isOn) async {
  //   themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
  //   await AppThemeCache.setIsLightMode(val: isOn);
  //   emit(themeMode);
  // }

//Hive
  ThemeMode themeMode =
      AppThemeHive.isLightTheme() ? ThemeMode.light : ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    await AppThemeHive.setIsLightMode(val: isOn);
    emit(themeMode);
  }
}
