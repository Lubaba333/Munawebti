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
      Get.snackbar("error".tr, "enter_email".tr);
      return;
    }

    if (!GetUtils.isEmail(emailAddress)) {
      Get.snackbar("error".tr, "enter_valid_email".tr);
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

      // 🔥 حماية إضافية
      if (response == null || response is! Map) {
        throw Exception("Invalid response from server");
      }

      print("✅ Reset OTP sent: $response");

      email.value = emailAddress;
      isOtpSent.value = true;

      Get.snackbar(
        "otp_sent".tr,
        "verification_code_sent".tr,
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
    // 🔥 التحقق من وجود البريد الإلكتروني
    if (email.value.isEmpty) {
      Get.snackbar(
        "error".tr,
        "email_not_found_retry".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    if (otp.length != 6) {
      Get.snackbar(
        "error".tr,
        "enter_otp_6digits".tr,
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

      if (response == null || response is! Map) {
        throw Exception("Invalid response from server");
      }

      print("✅ OTP Verified: $response");

      otpCode.value = otp;
      isOtpVerified.value = true;

      Get.snackbar(
        "success".tr,
        "code_verified_success".tr,
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
        "verification_failed".tr,
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
      Get.snackbar("error".tr, "enter_new_password".tr);
      return false;
    }

    if (newPassword.length < 6) {
      Get.snackbar("error".tr, "password_min_length".tr);
      return false;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("error".tr, "passwords_not_match".tr);
      return false;
    }

    // التأكد من أن OTP تم التحقق منه
    if (!isOtpVerified.value || otpCode.value.isEmpty) {
      Get.snackbar(
        "error".tr,
        "verify_otp_first".tr,
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

      if (response == null || response is! Map) {
        throw Exception("Invalid response from server");
      }

      print("✅ Password reset success: $response");

      // إعادة تعيين الحالة
      resetState();

      Get.snackbar(
        "success".tr,
        "password_changed_success".tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // العودة إلى Login بعد 2 ثانية
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() => LoginView());
      });
      
      return true;
      
    } catch (e) {
      print("❌ Reset password error: $e");
      
      String errorMessage = _extractErrorMessage(e);
      
      Get.snackbar(
        "reset_failed".tr,
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