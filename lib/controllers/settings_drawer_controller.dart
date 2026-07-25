import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/login.dart';
import 'profile_controller.dart';

class SettingsDrawerController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  final ApiService _apiService = ApiService(); // 🔥 أضفناها
var isLoading = false.obs;
  RxString get name => profileController.name;
  RxString get email => profileController.email;
  Rxn<File> get image => profileController.profileImage;

  /// 🚪 logout احترافي
Future<void> logout() async {
  try {
    isLoading.value = true;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("🔴 LOGOUT FCM TOKEN: $fcmToken");

    // 🟡 خبرّي الباك
    await _apiService.post(
      '/auth/student/logout',
      {
        "fcm_token": fcmToken,
      },
      authRequired: true,
    );

    // 🔥 أهم سطر (أنتِ ناقصك هذا)
    await FirebaseMessaging.instance.deleteToken();

    print("🗑️ FCM Token DELETED from device");

    // 🧹 احذفي التوكن المحلي
    await _apiService.setToken(null);

    // 🧹 تنظيف Controllers
    Get.delete<ProfileController>(force: true);

    // 🔁 رجوع لواجهة البداية
    Get.offAll(() =>  LoginView());

  } catch (e) {
    print("❌ Logout Error: $e");
  } finally {
    isLoading.value = false;
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