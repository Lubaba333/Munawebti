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
                      Text(
                        "enter_email_to_reset_password".tr,
                        style: const TextStyle(color: Colors.grey),
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
                          onTap: () async {
                            final email = emailController.text.trim();

                            if (email.isEmpty) {
                              Get.snackbar(
                                "error".tr,
                                "please_enter_email".tr,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (!GetUtils.isEmail(email)) {
                              Get.snackbar(
                                "error".tr,
                                "invalid_email".tr,
                                backgroundColor: Colors.red,
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