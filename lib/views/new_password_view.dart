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

  final ResetPasswordController controller = Get.put(ResetPasswordController());

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "new_password".tr,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Theme.of(context).cardColor.withOpacity(.96)
                          : Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isDark
                            ? AppColors.mauve.withOpacity(.16)
                            : Colors.white.withOpacity(.35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(.25)
                              : AppColors.deepPurple.withOpacity(.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: passwordController,
                          hint: "new_password".tr,
                          icon: Icons.lock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmController,
                          hint: "confirm_password".tr,
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),
                        Obx(
                          () => GradientButton(
                            text: controller.isLoading.value
                                ? "updating".tr
                                : "update_password".tr,
                            isLoading: controller.isLoading.value,
                            onTap: () {
                              if (passwordController.text !=
                                  confirmController.text) {
                                Get.snackbar(
                                  "error".tr,
                                  "passwords_not_match".tr,
                                  backgroundColor: isDark
                                      ? const Color(0xFF8B1E2D)
                                      : Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              controller.resetPassword(
                                passwordController.text,
                                confirmController.text,
                              );
                            },
                          ),
                        ),
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