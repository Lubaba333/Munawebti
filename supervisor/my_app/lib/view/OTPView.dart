import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/view/ResetPasswordView.dart';

class OTPView extends StatelessWidget {
  OTPView({super.key});

  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔥 نفس الخلفية
          _background(),

          /// 🔹 Content
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
                          "Verification Code",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Enter the code sent to your email",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textLight),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                            (i) => _otpField(i),
                          ),
                        ),

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

  Widget _otpField(int index) {
    return Container(
      width: 60,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
          }
        },
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onTap: () => Get.to(() => ResetPasswordView()),
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
            "Verify Code",
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