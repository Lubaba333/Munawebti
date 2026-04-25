import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/new_password_view.dart';


class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var isOtpVerified = false.obs;

  var email = "".obs;
  var otpCode = "".obs;

  /// 📧 الخطوة 1: إرسال رابط إعادة التعيين
  Future<void> sendResetLink(String emailAddress) async {
    if (emailAddress.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    if (!GetUtils.isEmail(emailAddress)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/password/email', // 🔥 حسب Laravel: POST /password/email
        {'email': emailAddress},
        authRequired: false,
      );

      print("✅ Reset link response: $response");

      email.value = emailAddress;
      isOtpSent.value = true;

      Get.snackbar(
        "Success",
        "Reset code sent to your email",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("❌ Send reset link error: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔐 الخطوة 2: التحقق من OTP
Future<void> verifyOtp(String otp) async {
  try {
    isLoading.value = true;

    final response = await _apiService.post(
      '/verify-otp',
      {
        'email': email.value,
        'otp': otp,
      },
      authRequired: false,
    );

    print("✅ OTP Verified: $response");

    otpCode.value = otp; // 🔥 خزّني الكود

    Get.snackbar(
      "Success",
      "Code verified successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /// 🔥 الانتقال مع القيم
    Get.to(() => NewPasswordView(
          email: email.value,
          otp: otp,
        ));

  } catch (e) {
    print("❌ OTP Error: $e");

    Get.snackbar(
      "Error",
      e.toString().replaceAll("Exception:", ""),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  /// 🔄 الخطوة 3: إعادة تعيين كلمة المرور
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty) {
      Get.snackbar("Error", "Please enter new password");
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/password/reset', // 🔥 POST /password/reset
        {
          'email': email.value,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        authRequired: false,
      );

      print("✅ Reset password response: $response");

      Get.snackbar(
        "Password Changed",
        "Login with your new password",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // العودة إلى Login
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed('/login');
      });
    } catch (e) {
      print("❌ Reset password error: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 إعادة تعيين الحالة (للاستخدام المتكرر)
  void resetState() {
    isOtpSent.value = false;
    isOtpVerified.value = false;
    email.value = "";
    otpCode.value = "";
  }
}