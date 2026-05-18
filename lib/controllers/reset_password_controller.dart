import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/login.dart';
import 'package:studants/views/new_password_view.dart';

class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isOtpSent = false.obs;
  var isOtpVerified = false.obs;

  var email = "".obs;
  var otpCode = "".obs;

  /// 📧 الخطوة 1: إرسال OTP لإعادة تعيين كلمة المرور (حسب Postman)
  Future<void> sendResetOTP(String emailAddress) async {
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

      // 🔥 المسار الصحيح من Postman
      final response = await _apiService.post(
        '/auth/password-reset/student/send-otp',
        {'email': emailAddress},
        authRequired: false,
      );

      print("✅ Reset OTP sent: $response");

      email.value = emailAddress;
      isOtpSent.value = true;

      Get.snackbar(
        "OTP Sent",
        "Verification code sent to your email",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("❌ Send reset OTP error: $e");
      
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔐 الخطوة 2: التحقق من OTP (حسب Postman)
  Future<bool> verifyOtp(String otp) async {
    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter the 6-digit OTP code",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    try {
      isLoading.value = true;

      // 🔥 المسار الصحيح من Postman
      final response = await _apiService.post(
        '/auth/password-reset/student/verify-otp',
        {
          'email': email.value,
          'otp': otp,
        },
        authRequired: false,
      );

      print("✅ OTP Verified: $response");

      otpCode.value = otp;
      isOtpVerified.value = true;

      Get.snackbar(
        "Success",
        "Code verified successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // 🔥 الانتقال إلى صفحة تعيين كلمة المرور الجديدة
      Get.to(() => NewPasswordView(
            email: email.value,
            otp: otp,
          ));
      
      return true;

    } catch (e) {
      print("❌ OTP Error: $e");
      
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Verification Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 الخطوة 3: إعادة تعيين كلمة المرور (حسب Postman)
  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty) {
      Get.snackbar("Error", "Please enter new password");
      return false;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return false;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    }

    // التأكد من أن OTP تم التحقق منه
    if (!isOtpVerified.value || otpCode.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please verify your OTP code first",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;

      // 🔥 المسار الصحيح من Postman
      final response = await _apiService.post(
        '/auth/password-reset/student/reset',
        {
          'email': email.value,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        authRequired: false,
      );

      print("✅ Password reset success: $response");

      // إعادة تعيين الحالة
      resetState();

      Get.snackbar(
        "Success",
        "Password changed successfully! Please login with your new password.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // العودة إلى Login بعد 2 ثانية
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() =>  LoginView());
      });
      
      return true;
      
    } catch (e) {
      print("❌ Reset password error: $e");
      
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "Reset Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 إعادة تعيين الحالة
  void resetState() {
    isOtpSent.value = false;
    isOtpVerified.value = false;
    email.value = "";
    otpCode.value = "";
  }
  
  /// 🔥 دالة مساعدة لاستخراج رسالة الخطأ
  String _extractErrorMessage(dynamic error) {
    String errorMessage = error.toString().replaceAll('Exception:', '').trim();
    
    if (errorMessage.contains('email')) {
      return "Email not found. Please enter a registered email.";
    }
    if (errorMessage.contains('otp') || errorMessage.contains('OTP')) {
      return "Invalid or expired OTP code. Please request a new one.";
    }
    
    return errorMessage;
  }
}