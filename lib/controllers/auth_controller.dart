// lib/modules/auth/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/home_view.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  
  var isEmailVerified = false.obs;
  var verifiedEmail = ''.obs;

  // ================= REGISTRATION FLOW =================
  
  Future<bool> sendRegistrationOTP({required String email}) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.post(
        '/auth/student/register/send-otp',
        {"email": email},
        authRequired: false,
      );
      
      print("✅ Registration OTP Sent: $response");
      
      verifiedEmail.value = email;
      isEmailVerified.value = false;
      
      Get.snackbar(
        "OTP Sent",
        "Verification code sent to $email",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      return true;
      
    } catch (e) {
      print("❌ Send OTP Error: $e");
      
      // استخراج رسالة الخطأ الحقيقية
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Failed to Send OTP",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> verifyRegistrationOTP({required String email, required String otp}) async {
    try {
      isLoading.value = true;
      
      final response = await _apiService.post(
        '/auth/student/register/verify-otp',
        {"email": email, "otp": otp},
        authRequired: false,
      );
      
      print("✅ OTP Verified Successfully: $response");
      
      isEmailVerified.value = true;
      
      Get.snackbar(
        "Success",
        "Email verified! You can now complete registration.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      return true;
      
    } catch (e) {
      print("❌ Verify OTP Error: $e");
      isEmailVerified.value = false;
      
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Verification Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> register({
    required String name,
    required String studentId,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int year,
    required String specialization,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isEmailVerified.value || email != verifiedEmail.value) {
      Get.snackbar(
        "Email Not Verified",
        "Please verify your email first by entering the OTP code",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/auth/student/register',
        {
          "full_name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
          "student_identifier": studentId,
          "phone_number": phone,
          "year": year,
          "specialization": specialization,
          "is_resident": true,
        },
        authRequired: false,
      );

      print("✅ Register Success: $response");

      final token = response['data']?['token'];

      if (token != null) {
        _apiService.setToken(token);
        await Get.find<ProfileController>().getProfile();
      }

      isEmailVerified.value = false;
      verifiedEmail.value = '';

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(() => HomeView());

    } catch (e) {
      print("❌ Register Error: $e");
      
      // 🔥 استخراج رسالة الخطأ التفصيلية
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Registration Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGIN =================
  Future<void> login({
    required String email,
    required String studantid,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/auth/student/login',
        {
          'email': email,
          'password': password,
          'student_identifier': studantid,
        },
        authRequired: false,
      );

      print("✅ Login Success: $response");

      final token = response['data']?['token'];

      if (token != null) {
        _apiService.setToken(token);
        await Get.find<ProfileController>().getProfile();
      }

      Get.snackbar(
        "Success",
        "Welcome back!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(() => HomeView());

    } catch (e) {
      print("❌ Login Error: $e");
      
      // 🔥 استخراج رسالة الخطأ التفصيلية
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Login Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 دالة مساعدة لاستخراج رسالة الخطأ الحقيقية من الـ API
  String _extractErrorMessage(dynamic error) {
    String errorMessage = error.toString().replaceAll('Exception:', '').trim();
    
    // رسائل مخصصة لأخطاء شائعة
    if (errorMessage.contains('student_identifier') && errorMessage.contains('already been taken')) {
      return "This Student ID is already registered. Please use a different one.";
    }
    if (errorMessage.contains('email') && errorMessage.contains('already been taken')) {
      return "This email is already registered. Please use a different email or login.";
    }
    if (errorMessage.contains('email') && errorMessage.contains('not verified')) {
      return "Email not verified. Please check your inbox and verify your email first.";
    }
    if (errorMessage.contains('phone') && errorMessage.contains('already been taken')) {
      return "This phone number is already registered.";
    }
    if (errorMessage.contains('invalid') && errorMessage.contains('credentials')) {
      return "Invalid email, Student ID, or password. Please try again.";
    }
    if (errorMessage.contains('OTP') || errorMessage.contains('otp')) {
      return "Invalid or expired OTP code. Please request a new one.";
    }
    
    return errorMessage;
  }
}