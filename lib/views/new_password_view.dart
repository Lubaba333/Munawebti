import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class NewPasswordView extends StatelessWidget {
  final String otp;
  final String email;

  NewPasswordView({
    super.key,
    required this.otp,
    required this.email,
  });

  final ResetPasswordController controller =
      Get.put(ResetPasswordController());

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  /// 💎 Glass Card
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: passwordController,
                          hint: "New Password",
                          icon: Icons.lock,
                          isPassword: true,
                        ),

                        const SizedBox(height: 15),

                        CustomTextField(
                          controller: confirmController,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 30),

                        Obx(() => GradientButton(
                              text: controller.isLoading.value
                                  ? "Updating..."
                                  : "Update Password",
                              onTap: () {
                                if (passwordController.text !=
                                    confirmController.text) {
                                  Get.snackbar("Error", "Passwords do not match");
                                  return;
                                }

controller.resetPassword(
  passwordController.text,
  confirmController.text,
);
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}