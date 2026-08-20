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

    try {
      await _apiService.post(
        '/auth/student/logout',
        {
          "fcm_token": fcmToken,
        },
        authRequired: true,
      );
    } catch (e) {
      print("⚠️ Logout API failed (ignored): $e");
    }

    await FirebaseMessaging.instance.deleteToken();
    print("🗑️ FCM Token DELETED");

    await _apiService.setToken(null);

    Get.delete<ProfileController>(force: true);

    Get.offAll(() => LoginView());
  } catch (e) {
    print("❌ Logout Error: $e");

    // 🔥 حتى لو فشل كل شي → رجعي للوغن
    Get.offAll(() => LoginView());
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