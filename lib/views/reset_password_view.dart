import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/otp.dart';

import 'package:studants/controllers/reset_password_controller.dart';

import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final emailController = TextEditingController();
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 14, top: 10),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(.18)),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "reset_password".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(.22)
                            : AppColors.deepPurple.withOpacity(.08),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "enter_email_to_reset_password".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: emailController,
                        hint: "email".tr,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => GradientButton(
                          text: controller.isLoading.value
                              ? "sending".tr
                              : "send_reset_code".tr,
                          isLoading: controller.isLoading.value,
                          onTap: () async {
                            final email = emailController.text.trim();

                            if (email.isEmpty) {
                              Get.snackbar(
                                "error".tr,
                                "please_enter_email".tr,
                                backgroundColor: isDark
                                    ? const Color(0xFF8B1E2D)
                                    : Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (!GetUtils.isEmail(email)) {
                              Get.snackbar(
                                "error".tr,
                                "invalid_email".tr,
                                backgroundColor: isDark
                                    ? const Color(0xFF8B1E2D)
                                    : Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            await controller.sendResetOTP(email);

                            if (controller.isOtpSent.value) {
                              Get.to(
                                () => const OtpVerificationView(),
                                arguments: {
                                  'email': email,
                                  'from': 'reset',
                                },
                              );
                            }
                          },
                        ),
                      ),
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