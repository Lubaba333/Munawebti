import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/home_controller.dart';
import '../../../utlis/app_colors.dart';

class MainCard extends StatelessWidget {
  final AnimationController animController;

  const MainCard({
    super.key,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {

        /// 🔥 الحركة الأساسية (float خفيفة)
        final floatY = animController.value * 6;

        return Transform.translate(
          offset: Offset(0, floatY),

          child: Stack(
            children: [

              /// 💜 الكارد الأساسي
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkPurple, AppColors.mauve],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),

                  /// ✨ ظل ناعم (بدون تخريب الشكل)
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    /// 🧾 المحتوى
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "المناوبة القادمة",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Obx(() => Text(
                                controller.hospital.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 5),

                              Obx(() => Text(
                                    controller.time.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 💫 العناصر العائمة (الأنيميشن تبعك)
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      _floating(Icons.favorite, 20, 70),
                      _floating(Icons.favorite_border, 70, 220),
                      _floating(Icons.medical_services, 30, 150),
                      _floating(Icons.health_and_safety, 50, 260),
                      _floating(Icons.local_hospital, 70, 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🟣 الأيقونات المتحركة (نفس فكرتك لكن أنعم)
  Widget _floating(IconData icon, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: animController,
        builder: (_, __) {

          /// 🔥 scale + نبض خفيف
          double scale = 0.85 + (animController.value * 0.5);

          /// ✨ شفافية متغيرة
          double opacity = 0.2 + (animController.value * 0.25);

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Icon(
                icon,
                size: 26,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}