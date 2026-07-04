import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/reset_password_view.dart';

import '../controllers/auth_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final AuthController controller = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final studantIdController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _headerSlide;
  late Animation<Offset> _formSlide;
  late Animation<double> _formScale;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _fade = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _formScale = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    passwordController.dispose();
    studantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.currentGradient,
          ),
          child: Stack(
            children: [
              _background(isDark),
              SafeArea(
                child: Column(
                  children: [
                    SlideTransition(
                      position: _headerSlide,
                      child: _header(),
                    ),
                    Expanded(
                      child: SlideTransition(
                        position: _formSlide,
                        child: ScaleTransition(
                          scale: _formScale,
                          child: _form(context),
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
    );
  }

  Widget _background(bool isDark) {
    return Stack(
      children: [
        _circle(
          80,
          40,
          30,
          isDark ? AppColors.mauve.withOpacity(.20) : AppColors.lightPink,
        ),
        _circle(60, 100, 300, Colors.white.withOpacity(0.16)),
        _circle(
          100,
          600,
          -20,
          isDark ? Colors.black.withOpacity(.18) : AppColors.deepPurple,
        ),
        _circle(
          90,
          -20,
          300,
          isDark ? AppColors.mauve.withOpacity(.22) : AppColors.mauve,
        ),
      ],
    );
  }

  Widget _circle(double size, double top, double left, Color color) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.75 + (_animController.value * 0.25),
            child: Opacity(
              opacity: _animController.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.login, color: Colors.white, size: 35),
          const SizedBox(height: 10),
          Text(
            "welcome_back".tr,
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.25)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              hint: "email".tr,
              icon: Icons.email,
            ),
            CustomTextField(
              controller: studantIdController,
              hint: "student_id".tr,
              icon: Icons.numbers,
            ),
            CustomTextField(
              controller: passwordController,
              hint: "password".tr,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ResetPasswordView());
                },
                child: Text(
                  "forgot_password".tr,
                  style: TextStyle(
                    color: isDark ? AppColors.mauve : AppColors.deepPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => GradientButton(
                text: controller.isLoading.value ? "loading".tr : "login".tr,
                isLoading: controller.isLoading.value,
                onTap: () {
                  controller.login(
                    email: emailController.text,
                    password: passwordController.text,
                    studantid: studantIdController.text,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "dont_have_account".tr,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterView());
                  },
                  child: Text(
                    "register".tr,
                    style: TextStyle(
                      color: isDark ? AppColors.mauve : AppColors.darkPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}