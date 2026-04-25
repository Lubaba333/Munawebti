// lib/modules/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var isLoading = false.obs;
  var isAgreed = false.obs;
  
  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }
  
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
        '/register',
        user.toJson(),
        authRequired: false,
      );
      
      print("✅ Register Success: $response");
      
      if (response.containsKey('token')) {
        _apiService.setToken(response['token']);
      }
      
      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to Login
      Get.offAllNamed('/login');
      
    } catch (e) {
      print("❌ Register Error: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 🔥 دالة Login الجديدة
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.post(
        '/login',
        {
          'email': email,
          'password': password,
        },
        authRequired: false,
      );
      
      print("✅ Login Success: $response");
      
      if (response.containsKey('token')) {
        _apiService.setToken(response['token']);
      }
      
      Get.snackbar(
        "Success",
        "Welcome back!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // TODO: Navigate to Home Screen
      // Get.offAllNamed('/home');
      
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