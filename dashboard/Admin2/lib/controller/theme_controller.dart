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

    // ⬇️ أهم تعديل: تأخير التطبيق بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.changeThemeMode(
        isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    storage.write('isDarkMode', isDarkMode.value);

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}