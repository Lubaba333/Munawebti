import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AdminLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // States
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Login function
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 🟣 محاكاة API (بدك تربطها مع ApiService تبعك)
      await Future.delayed(const Duration(seconds: 2));

      // مثال تحقق
      if (emailController.text == "admin@test.com" &&
          passwordController.text == "12345678") {

        // ✅ النجاح → دخول
        Get.offAllNamed(AppRoutes.dashboard);

      } else {
        // ❌ خطأ
        errorMessage.value = "بيانات غير صحيحة";
      }

      // نجاح
      Get.snackbar(
        "نجاح",
        "تم تسجيل الدخول",
        snackPosition: SnackPosition.BOTTOM,
      );

      // TODO: الانتقال للداشبورد
      // Get.offAllNamed('/dashboard');

    } catch (e) {
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}