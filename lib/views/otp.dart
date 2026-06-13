import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/auth_controller.dart';
import 'package:studants/controllers/reset_password_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/gradient_button.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {

  // متغيرات للحالتين
  AuthController? authController;
  ResetPasswordController? resetController;
  
  // متغير لتحديد أي كونترولر نستخدم
  RxBool isLoading = false.obs;
  RxString email = ''.obs;
  bool isResetMode = false;

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    
    final args = Get.arguments;
    
    // تحديد نوع العملية من المعاملات
    if (args != null && args is Map && args.containsKey('from')) {
      isResetMode = args['from'] == 'reset';
    } else {
      // محاولة اكتشاف تلقائي
      try {
        resetController = Get.find<ResetPasswordController>();
        if (resetController!.email.value.isNotEmpty) {
          isResetMode = true;
        } else {
          throw Exception();
        }
      } catch (_) {
        isResetMode = false;
      }
    }
    
    if (isResetMode) {
      // وضع إعادة تعيين كلمة المرور
      try {
        resetController = Get.find<ResetPasswordController>();
        isLoading = resetController!.isLoading;
        email = resetController!.email;
        
        if (email.value.isEmpty && args != null && args['email'] != null) {
          resetController!.email.value = args['email'];
          email.value = args['email'];
        }
        
        print("✅ Reset Mode - Email: ${email.value}");
      } catch (e) {
        print("❌ Error finding ResetPasswordController: $e");
        Get.back();
      }
    } else {
      // وضع التسجيل
      try {
        authController = Get.find<AuthController>();
        isLoading = authController!.isLoading;
        
        if (args != null && args['email'] != null) {
          authController!.verifiedEmail.value = args['email'];
          email.value = args['email'];
        } else {
          email.value = authController!.verifiedEmail.value;
        }
        
        print("✅ Register Mode - Email: ${email.value}");
      } catch (e) {
        print("❌ Error finding AuthController: $e");
        Get.back();
      }
    }
    
    // تحقق من وجود البريد الإلكتروني
    if (email.value.isEmpty) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          "Error",
          "Email not found. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
      });
    }
  }

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
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String _getFullOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyOtp() async {
    String fullOtp = _getFullOtp();

    if (fullOtp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter the 6-digit code",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isResetMode && resetController != null) {
      // وضع إعادة تعيين كلمة المرور
      bool success = await resetController!.verifyOtp(fullOtp);
      if (success) {
        // verifyOtp يقوم بالانتقال إلى NewPasswordView
      }
    } else if (authController != null) {
      // وضع التسجيل
      bool success = await authController!.verifyRegistrationOTP(
        email: email.value,
        otp: fullOtp,
      );
      
      if (success) {
        final args = Get.arguments;
        if (args != null && args is Map) {
          await authController!.register(
            name: args['name'],
            studentId: args['studentId'],
            email: email.value,
            password: args['password'],
            confirmPassword: args['confirmPassword'],
            phone: args['phone'],
            year: int.parse(args['year']),
            specialization: args['specialization'],
          );
        }
      }
    }
  }

  void _resendOtp() async {
    if (isResetMode && resetController != null) {
      await resetController!.sendResetOTP(email.value);
    } else if (authController != null) {
      await authController!.sendRegistrationOTP(email: email.value);
    }
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
                  const Text(
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We sent a 6-digit code to your email",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    email.value.isNotEmpty 
                        ? email.value 
                        : "your email",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(height: 35),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                       Row(
  children: List.generate(6, (index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: _buildOtpBox(index),
      ),
    );
  }),
),
                        const SizedBox(height: 35),

                        Obx(() => GradientButton(
                          text: isLoading.value ? "VERIFYING..." : "Verify Code",
                          onTap: _verifyOtp,
                        )),

                        const SizedBox(height: 20),

                        Obx(() => TextButton(
                          onPressed: isLoading.value ? null : _resendOtp,
                          child: const Text(
                            "Didn't receive code? Resend",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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

  Widget _buildOtpBox(int index) {
    return Container(
      
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }
}