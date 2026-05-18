// lib/views/otp_verification_view.dart
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/auth_controller.dart';

import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/gradient_button.dart';

class OtpVerificationView extends StatelessWidget {
  OtpVerificationView({super.key});
  
  final AuthController authController = Get.find();
  final TextEditingController otpController = TextEditingController();
  
  final String email = Get.arguments['email'] ?? '';
  final String name = Get.arguments['name'] ?? '';
  final String studentId = Get.arguments['studentId'] ?? '';
  final String password = Get.arguments['password'] ?? '';
  final String confirmPassword = Get.arguments['confirmPassword'] ?? '';
  final String phone = Get.arguments['phone'] ?? '';
  final String year = Get.arguments['year'] ?? '';
  final String specialization = Get.arguments['specialization'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: Stack(
          children: [
            _background(),
            SafeArea(
              child: Column(
                children: [
                  _header(),
                  Expanded(child: _form()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        _circle(80, 40, 30, AppColors.lightPink),
        _circle(60, 100, 300, Colors.white.withOpacity(0.2)),
        _circle(100, 600, -20, AppColors.deepPurple),
        _circle(90, -20, 300, AppColors.mauve),
      ],
    );
  }

  Widget _circle(double size, double top, double left, Color color) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.verified_user, color: Colors.white, size: 35),
          SizedBox(height: 10),
          Text(
            "Verify Email",
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Enter 6-Digit OTP Code",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkPurple,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "We sent a verification code to\n$email",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: otpController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "000000",
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.lightPink),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.darkPurple, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Obx(() => GradientButton(
            text: authController.isLoading.value ? "Verifying..." : "Verify OTP",
            onTap: () async {
              String otp = otpController.text.trim();
              
              if (otp.length != 6) {
                Get.snackbar(
                  "Error",
                  "Please enter the 6-digit OTP code",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              
              final verified = await authController.verifyRegistrationOTP(
                email: email,
                otp: otp,
              );
              
              if (verified) {
                await authController.register(
                  name: name,
                  studentId: studentId,
                  email: email,
                  password: password,
                  confirmPassword: confirmPassword,
                  phone: phone,
                  year: int.tryParse(year) ?? 1,
                  specialization: specialization,
                );
              }
            },
          )),
          
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              await authController.sendRegistrationOTP(email: email);
            },
            child: const Text(
              "Resend Code",
              style: TextStyle(color: AppColors.darkPurple),
            ),
          ),
        ],
      ),
    );
  }
}*/