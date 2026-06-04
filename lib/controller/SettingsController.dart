import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {

  final box = GetStorage();

  /// OBS
  final isDarkMode = false.obs;
  final locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// ================= LOAD =================
  void _loadSettings() {
    isDarkMode.value = box.read('darkMode') ?? false;

    final lang = box.read('lang') ?? 'en';

    locale.value = lang == 'ar'
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');

    _applyTheme();
    _applyLanguage();
  }

  /// ================= DARK MODE =================
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    box.write('darkMode', isDarkMode.value);

    _applyTheme();
  }

  void _applyTheme() {
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  /// ================= LANGUAGE =================
  void changeLanguage(String lang) {
    if (lang == 'ar') {
      locale.value = const Locale('ar', 'SA');
    } else {
      locale.value = const Locale('en', 'US');
    }

    box.write('lang', lang);

    _applyLanguage();
  }

  void _applyLanguage() {
    Get.updateLocale(locale.value);
  }
}