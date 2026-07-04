import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lecture_attendance_controller.dart';
import '../models/lecture_attendance_model.dart';
import '../utlis/app_colors.dart';
import 'lecture_attendance_detail_view.dart';

class LectureAttendanceView extends StatelessWidget {
  LectureAttendanceView({super.key});

  final controller = Get.put(LectureAttendanceController());

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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(.22)
                            : AppColors.deepPurple.withOpacity(.08),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.attendanceList.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    if (controller.attendanceList.isEmpty) {
                      return _emptyState(context);
                    }

                    return RefreshIndicator(
                      color: AppColors.mauve,
                      onRefresh: controller.fetchAttendance,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                        itemCount: controller.attendanceList.length,
                        itemBuilder: (_, index) {
                          final item = controller.attendanceList[index];
                          return _attendanceCard(context, item);
                        },
                      ),
                    );
                  }),
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
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
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
            child: const Icon(
              Icons.fact_check_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "lecture_attendance".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "lecture_attendance_subtitle".tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(BuildContext context, LectureAttendanceModel item) {
    final isDark = Get.isDarkMode;
    final statusColor = _statusColor(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withOpacity(.22)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.20)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _statusIcon(item.status),
              color: statusColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subjectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${item.day} • ${item.fromHour} - ${item.toHour}",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _smallChip(
                      text: _statusText(item.status),
                      color: statusColor,
                      icon: Icons.circle,
                    ),
                    _smallChip(
                      text: item.type,
                      color: isDark ? AppColors.mauve : AppColors.darkPurple,
                      icon: Icons.menu_book_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await controller.fetchAttendanceDetails(item.id);
              Get.to(() => const LectureAttendanceDetailView());
            },
            style: TextButton.styleFrom(
              foregroundColor: isDark ? AppColors.mauve : AppColors.darkPurple,
            ),
            child: Text("details".tr),
          ),
        ],
      ),
    );
  }

  Widget _smallChip({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Get.isDarkMode ? color.withOpacity(.18) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Text(
        "no_lecture_attendance_records".tr,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'present') return Colors.green;
    if (status == 'absent') return Colors.red;
    if (status == 'excused') return Colors.orange;
    return Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple;
  }

  IconData _statusIcon(String status) {
    if (status == 'present') return Icons.check_circle_rounded;
    if (status == 'absent') return Icons.cancel_rounded;
    if (status == 'excused') return Icons.info_rounded;
    return Icons.help_rounded;
  }

  String _statusText(String status) {
    if (status == 'present') return "present".tr;
    if (status == 'absent') return "absent".tr;
    if (status == 'excused') return "excused".tr;
    return status;
  }
}