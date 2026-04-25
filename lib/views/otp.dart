import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/new_password_view.dart';

import '../controllers/reset_password_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/gradient_button.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  final List<TextEditingController> _otpControllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 4) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String _getFullOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🏷️ Title
                  const Text(
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// 📧 Subtitle
                  Text(
                    "We sent a 5-digit code to your email",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.email.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 35),

                  /// 💎 Glass Card (شفاف)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // 🔥 شفافية عالية
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// 🔢 5 OTP Boxes (مصغرة)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return _buildOtpBox(index);
                          }),
                        ),

                        const SizedBox(height: 35),

                        /// 🚀 Verify Button
                        Obx(() => GradientButton(
                              text: controller.isLoading.value
                                  ? "VERIFYING..."
                                  : "Verify Code",
onTap: () {
  String fullOtp = _getFullOtp();

  if (fullOtp.length == 5) {
    // 🔥 بدل ما تعملي reset هون → روحي لصفحة تغيير كلمة المرور
    Get.to(() => NewPasswordView(
          otp: fullOtp,
          email: controller.email.value,
        ));
  } else {
    Get.snackbar(
      "Error",
      "Please enter the 5-digit code",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
},
                              isLoading: controller.isLoading.value,
                            )),

                        const SizedBox(height: 20),

                        /// 🔁 Resend Code
                        TextButton(
                          onPressed: () {
                            controller.sendResetLink(controller.email.value);
                          },
                          child: const Text(
                            "Didn't receive code? Resend",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
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

  Widget _buildOtpBox(int index) {
    return Container(
      width: 48,  // 🔥 أصغر من قبل
      height: 55, // 🔥 أصغر من قبل
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85), // 🔥 شفافية خفيفة
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkPurple,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
        ),
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }
}