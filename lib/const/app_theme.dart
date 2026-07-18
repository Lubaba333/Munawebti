import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// ============== LIGHT THEME ==============
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primary,
      cardColor: AppColors.surfaceLight,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
        bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
        bodySmall: TextStyle(color: AppColors.textSecondaryLight),
        titleLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.textPrimaryLight),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),

      dividerTheme: const DividerThemeData(color: Colors.black12),

      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.primary : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary.withOpacity(0.5)
              : Colors.grey.shade300,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.primary : Colors.grey,
        ),
      ),

      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimaryLight,
        iconColor: AppColors.textPrimaryLight,
      ),
    );
  }

  /// ============== DARK THEME ==============
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primary,
      cardColor: AppColors.surfaceDark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
        bodySmall: TextStyle(color: AppColors.textSecondaryDark),
        titleLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.textPrimaryDark),
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),

      dividerTheme: const DividerThemeData(color: Colors.white24),

      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.accent : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accent.withOpacity(0.5)
              : Colors.grey.shade700,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.accent : Colors.grey,
        ),
      ),

      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimaryDark,
        iconColor: AppColors.textPrimaryDark,
      ),
    );
  }
}





// // ===== Settings =====
// 'settings': 'الإعدادات',
// 'appearance': 'المظهر',
// 'dark_mode': 'الوضع الليلي',
// 'currently_on': 'مفعّل حاليًا',
// 'currently_off': 'غير مفعّل',
// 'language': 'اللغة',
// 'about': 'حول',
// 'about_app': 'حول التطبيق',
// 'munawebti':'مناويتي',
// 'Version 1.0.0':'الإصدار1.0.0',
// 'about_app_subtitle': 'الإصدار، معلومات المطوّر',
// 'about_description':
// 'تطبيق للمشرفين لإدارة الطلاب، الجداول، الطلبات وحالات الطوارئ.',
//
// // ===== Home =====
// 'welcome': 'أهلاً 👋',
// 'current_shift': 'المناوبة الحالية',
// 'no_shift': 'لا توجد مناوبة',
// 'active_now': 'نشط الآن',
// 'quick_actions': 'إجراءات سريعة',
// 'emergency': 'طوارئ',
// 'complaints': 'الشكاوى',
// 'requests': 'الطلبات',
// 'attendance': 'الحضور',
// 'todays_schedule': 'جدول اليوم',
// 'No time available':'الوقت غير متاح',
// 'place':'اسم المبنى',
// 'teacher':'الاستاذ',
// 'lab':'الموقع',
// ===== Settings =====
// 'settings': 'Settings',
// 'appearance': 'Appearance',
// 'dark_mode': 'Dark Mode',
// 'currently_on': 'Currently on',
// 'currently_off': 'Currently off',
// 'language': 'Language',
// 'about': 'About',
// 'about_app': 'About App',
// 'munawebti':'Munawebti',
// 'Version 1.0.0':'Version 1.0.0',
// 'about_app_subtitle': 'Version, developer info',
// 'about_description':
// 'An app for supervisors to manage students, schedules, requests and emergencies.',
//
// // ===== Home =====
// 'welcome': 'Welcome 👋',
// 'current_shift': 'Current Shift',
// 'no_shift': 'No Shift',
// 'active_now': 'Active Now',
// 'quick_actions': 'Quick Actions',
// 'emergency': 'Emergency',
// 'complaints': 'Complaints',
// 'requests': 'Requests',
// 'attendance': 'Attendance',
// 'todays_schedule': "Today's Schedule",
// 'No time available':'No time available',
// 'place':'place',
// 'teacher':'teacher',
// 'lab':'lab',




