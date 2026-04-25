import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/otp.dart';

import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final emailController = TextEditingController();

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
              /// 🔙 Back
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),

              /// 🏷️ Title
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

              /// 🪟 Card
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

                      GradientButton(
                        text: "Send Reset Link",
                        onTap: () {
                         /* Get.snackbar(
                            "Success",
                            "Reset link sent to your email",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );*/
                          Get.to(OtpVerificationView());
                        },
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