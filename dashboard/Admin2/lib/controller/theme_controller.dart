import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final storage = GetStorage();

  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    // اقرأ الحالة المحفوظة
    isDarkMode.value = storage.read('isDarkMode') ?? false;

    // طبّق الثيم مباشرة عند فتح التطبيق
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    // احفظ الحالة
    storage.write('isDarkMode', isDarkMode.value);

    // طبّق الثيم فوراً
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}