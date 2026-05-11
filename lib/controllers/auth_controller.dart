// lib/modules/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/home_view.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isAgreed = false.obs;

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  /// ================= REGISTER =================
  Future<void> register(UserModel user) async {
    if (!isAgreed.value) {
      Get.snackbar(
        "Agreement Required",
        "Please agree to the Terms & Conditions",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/auth/student/register', // ✅ عدلي إذا غير موجود بالباك
        user.toJson(),
        authRequired: false,
      );

      print("✅ Register Success: $response");

      /// 🔥 التوكن جوا data
      final token = response['data']?['token'];

      if (token != null) {
        _apiService.setToken(token);
      }

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/login');

    } catch (e) {
      print("❌ Register Error: $e");

      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= LOGIN =================
  Future<void> login({
    required String email,
    required String studantid,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/auth/student/login', // ✅ endpoint الصحيح
        {
          'email': email,
          'password': password,
          'student_identifier': studantid, // ✅ الاسم الصحيح
        },
        authRequired: false,
      );

      print("✅ Login Success: $response");

      /// 🔥 التوكن داخل data
      final token = response['data']?['token'];

      if (token != null) {
        _apiService.setToken(token);
      }

      Get.snackbar(
        "Success",
        "Welcome back!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      /// 🔥 انتقال بعد تسجيل الدخول
      Get.offAll(HomeView());

    } catch (e) {
      print("❌ Login Error: $e");

      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}