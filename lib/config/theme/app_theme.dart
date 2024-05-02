import 'package:flutter/material.dart';
import '../config_export.dart';

class AppThemes {
  //ADD LIGHT THEME
  static final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkGrey),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme().copyWith(
        fillColor: AppColors.lightGrey,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        filled: true,
        hintStyle:
            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.lightGrey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.black, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGrey,
              shadowColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white)));
  //ADD DARK THEME
  static final darkTheme = ThemeData(useMaterial3: true);
}
