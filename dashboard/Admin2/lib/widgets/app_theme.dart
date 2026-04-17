import 'package:flutter/material.dart';
import '../widgets/AppColors.dart';

class AppTheme {
  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FB),

    primaryColor: AppColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),

    cardColor: Colors.white,

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  /// 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E2F),

    primaryColor: AppColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A2A40),
      elevation: 0,
    ),

    cardColor: const Color(0xFF2A2A40),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}