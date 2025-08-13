import 'package:flutter/material.dart';
import '../config_export.dart';

class AppThemes {
  final BuildContext context;
  AppThemes({required this.context});

  factory AppThemes.of(BuildContext context) {
    return AppThemes(context: context);
  }
  //ADD LIGHT THEME
  final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF202225),
    canvasColor: Color(0xFF2F3136),
    cardColor: Color(0xFF36393E),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF5336ff),
      onPrimary: Colors.white,
      secondary: Color(0xFF5336ff),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2F3136),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2F3136),
      selectedItemColor: Color(0xFF5336ff),
      unselectedItemColor: Colors.grey,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5336ff), // replaces primary
        foregroundColor: Colors.white, // replaces onPrimary
        shape: StadiumBorder(),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70), // replaces bodyText1
      bodyMedium: TextStyle(color: Colors.white60), // replaces bodyText2
    ),
    iconTheme: IconThemeData(color: Colors.white70),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2F3136), // Discord's panel gray
      hintStyle: TextStyle(color: Colors.white38), // muted placeholder
      labelStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: Color(0xFF202225),
        ), // deep background border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Color(0xFF202225)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(
          color: Color(0xFF5336ff),
          width: 2,
        ), // Discord blue focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    ),
  );
}
