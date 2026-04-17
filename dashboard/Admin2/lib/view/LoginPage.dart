import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/admin_login_controller.dart';
import '../widgets/AppColors.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomTextField.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  late final AdminLoginController controller;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();

    // ✅ ربط الكنترولر بشكل صحيح
    controller = Get.put(AdminLoginController());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      curve: Curves.easeOutCubic,
      parent: _animationController,
    ));

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      curve: Curves.easeOutCubic,
      parent: _animationController,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Directionality(
        textDirection: TextDirection.rtl, // الحفاظ على RTL
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: constraints.maxWidth > 800
              ? _buildWebLayout(constraints)
              : _buildMobileLayout(),
        ),
      );
    });
  }

  // ==========================
  // WEB
  // ==========================
  Widget _buildWebLayout(BoxConstraints c) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SlideTransition(
            position: _leftSlideAnimation,
            child: ClipPath(
              clipper: _SlantedClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -50,
                      child: _circle(),
                    ),
                    Positioned(
                      bottom: -80,
                      right: -80,
                      child: _circle(),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.local_hospital,
                              color: Colors.white70, size: 70),
                          SizedBox(height: 30),
                          Text(
                            "Admin Dashboard",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Administrator Only",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 18),
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

        // Login Card
        Expanded(
          flex: 4,
          child: SlideTransition(
            position: _rightSlideAnimation,
            child: Center(
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.12),
                    )
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Please Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email
                      CustomTextField(
                        controller: controller.emailController,
                        hint: "Email",
                        icon: Icons.email_outlined,
                        isPassword: false,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Email is required";
                          }
                          if (!GetUtils.isEmail(v)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                        controller: controller.passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        isPassword: !_showPassword,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Password is required";
                          }
                          if (v.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Error
                      Obx(() {
                        if (controller.errorMessage.value.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                                color: Colors.redAccent),
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      // Button
                      Obx(() {
                        return CustomButton(
                          text: controller.isLoading.value
                              ? "Logging in..."
                              : "Login",
                          onPressed: controller.isLoading.value
                              ? () {}
                              : controller.login,
                        );
                      }),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================
  // MOBILE
  // ==========================
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _mobileHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildWebLayout(BoxConstraints()),
          ),
        ],
      ),
    );
  }

  Widget _mobileHeader() {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
        ),
      ),
      child: const Center(
        child: Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Clipper
class _SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.15, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}