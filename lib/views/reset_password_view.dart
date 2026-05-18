import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/otp.dart';
import 'package:studants/views/otp_verification_view.dart';
import 'package:studants/controllers/reset_password_controller.dart';

import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final emailController = TextEditingController();
  final ResetPasswordController controller = Get.put(ResetPasswordController()); // ✅ التسجيل هنا

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Enter your email to reset password",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 30),
                      Obx(() => GradientButton(
                        text: controller.isLoading.value ? "Sending..." : "Send Reset Code",
                        onTap: () async {
                          final email = emailController.text.trim();
                          
                          if (email.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please enter your email",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          
                          if (!GetUtils.isEmail(email)) {
                            Get.snackbar(
                              "Error",
                              "Please enter a valid email address",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          
                          await controller.sendResetOTP(email);
                          
                          if (controller.isOtpSent.value) {
                            Get.to(() => const OtpVerificationView());
                          }
                        },
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}