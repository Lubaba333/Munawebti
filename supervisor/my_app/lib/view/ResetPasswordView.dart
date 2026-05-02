import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/controller/AuthController.dart';

class ResetPasswordView extends StatelessWidget {
  final controller = Get.find<AuthController>();

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          _background(),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.glassBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Text(
                          "Create New Password",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Enter your new password below",
                          style: TextStyle(color: AppColors.textLight),
                        ),

                        const SizedBox(height: 25),

                        Obx(() => _field(
                              "New Password",
                              Icons.lock,
                              controller.isPasswordHidden.value,
                              (v) => controller.password.value = v,
                              controller.togglePassword,
                            )),

                        const SizedBox(height: 15),

                        Obx(() => _field(
                              "Confirm Password",
                              Icons.lock_outline,
                              controller.isConfirmHidden.value,
                              (v) => controller.confirmPassword.value = v,
                              controller.toggleConfirm,
                            )),

                        const SizedBox(height: 25),

                        _button(),

                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: AppColors.textLight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String hint, IconData icon, bool isPassword,
      Function(String) onChanged, VoidCallback toggle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: isPassword,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.textLight),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textLight,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onTap: controller.resetPassword,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.buttonGradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: const Center(
          child: Text(
            "Reset Password",
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.mainGradient,
            ),
          ),
        ),
        Positioned(top: -50, left: -50, child: _blurCircle(200)),
        Positioned(bottom: -60, right: -60, child: _blurCircle(250)),
      ],
    );
  }

  Widget _blurCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blur,
      ),
    );
  }
}