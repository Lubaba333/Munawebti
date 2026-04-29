import 'package:flutter/material.dart';
import '../widgets/AppColors.dart';

class AppTheme {
  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FB),

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),

    cardColor: Colors.white,

    iconTheme: const IconThemeData(color: Colors.black87),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),

    useMaterial3: true,
  );

  /// 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E2F),

    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A2A40),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardColor: const Color(0xFF2A2A40),

    iconTheme: const IconThemeData(color: Colors.white70),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),

    useMaterial3: true,
  );
}