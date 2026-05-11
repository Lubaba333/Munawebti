import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/login.dart';
import 'profile_controller.dart';

class SettingsDrawerController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  final ApiService _apiService = ApiService(); // 🔥 أضفناها

  RxString get name => profileController.name;
  RxString get email => profileController.email;
  Rxn<File> get image => profileController.profileImage;

  /// 🚪 logout احترافي
  Future<void> logout() async {
    try {
      // 🔥 حذف التوكن
      _apiService.setToken(null);

      // (اختياري) إذا عندك API logout
      // await _apiService.post('/auth/logout', {}, authRequired: true);

      // 🔥 تنظيف بيانات المستخدم
      profileController.clearProfile(); // إذا موجودة

      // 🔥 إعادة التوجيه
      Get.offAll(() =>  LoginView());

    } catch (e) {
      print("❌ Logout Error: $e");
    }
  }

  void goTo(String route) {
    Get.back();
    Get.toNamed(route);
  }

  void toggleTheme() {
    Get.back();
    Get.changeThemeMode(
        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}