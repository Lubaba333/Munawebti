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
        final floatY = animController.value * 6;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkPurple, AppColors.mauve],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
                      "المحاضرة القادمة".tr,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Obx(
                      () => Text(
                        controller.hospital.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Obx(
                      () => Text(
                        controller.day.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => Text(
                                controller.time.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => Text(
                                controller.location.value.isEmpty
                                    ? "غير محدد".tr
                                    : controller.location.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      _floating(Icons.menu_book_rounded, 20, 70),
                      _floating(Icons.school_rounded, 70, 220),
                      _floating(Icons.edit_note_rounded, 30, 150),
                      _floating(Icons.calendar_month_rounded, 50, 260),
                      _floating(Icons.science_rounded, 70, 40),
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

  Widget _floating(IconData icon, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: animController,
        builder: (_, __) {
          final scale = 0.85 + (animController.value * 0.5);
          final opacity = 0.2 + (animController.value * 0.25);

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