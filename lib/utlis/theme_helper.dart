import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    isDarkMode.value = box.read('isDarkMode') ?? false;

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  ThemeMode get themeMode {
    return isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(bool isDark) {
    isDarkMode.value = isDark;

    box.write('isDarkMode', isDark);

    Get.changeThemeMode(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}