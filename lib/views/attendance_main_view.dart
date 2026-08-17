import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/HousingAttendanceView.dart';
import 'package:studants/views/LectureAttendancehistory.dart';
import 'package:studants/views/HouseAttendancehistory_view.dart';
import 'package:studants/views/lecture_attendance_view.dart';

class AttendanceMainView extends StatefulWidget {
  const AttendanceMainView({super.key});

  @override
  State<AttendanceMainView> createState() => _AttendanceMainViewState();
}

class _AttendanceMainViewState extends State<AttendanceMainView> with TickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(.2) : AppColors.darkPurple.withOpacity(.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _categoryRow(
                          context,
                          title: "lecture_attendance".tr,
                          subtitle: "lecture_attendance_subtitle".tr,
                          icon: Icons.school_rounded,
                          accentColor: AppColors.darkPurple,
                          onCheckIn: () => Get.to(() => LectureAttendanceView()),
                          onHistory: () => Get.to(() => const AttendanceHistoryView()),
                        ),
                        const SizedBox(height: 14),
                        _categoryRow(
                          context,
                          title: "housing_attendance".tr,
                          subtitle: "housing_attendance_subtitle".tr,
                          icon: Icons.home_rounded,
                          accentColor: const Color(0xFF2C7A7B),
                          onCheckIn: () => Get.to(() => HousingAttendanceView()),
                          onHistory: () => Get.to(() => const HousingAttendanceHistoryView()),
                        ),

                        // المساحة الفارغة تحت الكاردات — رسمة متحركة (Floating)
                        _floatingIllustration(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(Icons.qr_code, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "attendance".tr,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onCheckIn,
    required VoidCallback onHistory,
  }) {
    final isDark = Get.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.03) : Colors.grey.withOpacity(.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(.06) : Colors.black.withOpacity(.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11.5, color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                    child: Text("check_in".tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 42,
                child: TextButton.icon(
                  onPressed: onHistory,
                  style: TextButton.styleFrom(
                    foregroundColor: accentColor,
                    backgroundColor: accentColor.withOpacity(.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: const Icon(Icons.history_rounded, size: 17),
                  label: Text("history".tr, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _floatingIllustration(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            final t = _floatController.value;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.translate(
                  offset: Offset(0, -10 + (t * 20)),
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkPurple.withOpacity(isDark ? .14 : .08),
                    ),
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      size: 52,
                      color: AppColors.darkPurple.withOpacity(.55),
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  top: 30 - (t * 16),
                  child: Opacity(
                    opacity: 0.35 + (t * 0.25),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2C7A7B).withOpacity(isDark ? .18 : .10),
                      ),
                      child: const Icon(Icons.home_rounded, size: 22, color: Color(0xFF2C7A7B)),
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  bottom: 34 - ((1 - t) * 16),
                  child: Opacity(
                    opacity: 0.35 + ((1 - t) * 0.25),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.mauve.withOpacity(isDark ? .18 : .12),
                      ),
                      child: Icon(Icons.check_circle_rounded, size: 20, color: AppColors.mauve),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  child: Text(
                    "scan_qr_hint".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}