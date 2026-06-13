import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/warning_details_controller.dart';
import '../utlis/app_colors.dart';

class WarningDetailsView extends StatelessWidget {
  final int id;

  const WarningDetailsView({super.key, required this.id});

  static const warningOrange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WarningDetailsController(id));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: const Text("تفاصيل التنبيه"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          );
        }

        if (controller.warning.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final w = controller.warning;

        return Stack(
          children: [
            _background(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _warningHeader(w['title'] ?? ''),
                  const SizedBox(height: 18),
                  _item(
                    title: "Description",
                    value: w['description'],
                    icon: Icons.description_outlined,
                  ),
                  _item(
                    title: "Date",
                    value: w['created_at'],
                    icon: Icons.calendar_month_rounded,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _warningHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: warningOrange,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: warningOrange.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.notifications_active_rounded,
              size: 110,
              color: Colors.white.withOpacity(.13),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(.35),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 46,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "WARNING",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required dynamic value,
    required IconData icon,
  }) {
    if (value == null) return const SizedBox();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warningOrange.withOpacity(.14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: warningOrange.withOpacity(.12),
            child: Icon(icon, color: warningOrange, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(200, AppColors.lightPink.withOpacity(0.40)),
        ),
        Positioned(
          top: 160,
          right: -70,
          child: _circle(190, warningOrange.withOpacity(0.16)),
        ),
        Positioned(
          bottom: -90,
          left: 50,
          child: _circle(230, AppColors.mauve.withOpacity(0.22)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
