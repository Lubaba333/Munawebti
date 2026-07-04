import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lecture_attendance_controller.dart';
import '../utlis/app_colors.dart';

class LectureAttendanceDetailView extends StatelessWidget {
  const LectureAttendanceDetailView({super.key});

  static const attendanceColor = AppColors.mauve;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LectureAttendanceController>();

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
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Obx(() {
                    final item = controller.selectedAttendance.value;

                    if (controller.isLoading.value || item == null) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _certificateHeader(
                            context,
                            title: item.subjectName,
                            status: item.status,
                          ),
                          const SizedBox(height: 22),
                          _certificateItem(
                            context,
                            icon: Icons.fact_check_rounded,
                            title: "status".tr,
                            value: _statusText(item.status),
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.calendar_month_rounded,
                            title: "attendance_date".tr,
                            value: item.attendanceDate,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.person_rounded,
                            title: "doctor".tr,
                            value: item.teacherName,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.access_time_rounded,
                            title: "time".tr,
                            value: "${item.fromHour} - ${item.toHour}",
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.today_rounded,
                            title: "day".tr,
                            value: item.day,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.location_on_rounded,
                            title: "location".tr,
                            value: item.labName,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.groups_rounded,
                            title: "group".tr,
                            value: item.groupNumber,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.account_tree_rounded,
                            title: "section".tr,
                            value: item.branch,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.menu_book_rounded,
                            title: "lecture_type".tr,
                            value: item.type,
                            showDivider: false,
                          ),
                        ],
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
                  "attendance_details".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "view_lecture_attendance_record".tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certificateHeader(
    BuildContext context, {
    required String title,
    required String status,
  }) {
    final color = _statusColor(status);

    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: color.withOpacity(.13),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(.30), width: 2),
          ),
          child: Icon(
            _statusIcon(status),
            color: color,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "lecture_attendance_record_single".tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _statusText(status),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Divider(
          height: 1,
          color: Theme.of(context).dividerColor.withOpacity(.35),
        ),
      ],
    );
  }

  Widget _certificateItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: attendanceColor, size: 23),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? "not_specified".tr : value,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(.35),
          ),
      ],
    );
  }

  Color _statusColor(String status) {
    if (status == 'present') return Colors.green;
    if (status == 'absent') return Colors.red;
    if (status == 'excused') return Colors.orange;
    return AppColors.mauve;
  }

  IconData _statusIcon(String status) {
    if (status == 'present') return Icons.check_circle_rounded;
    if (status == 'absent') return Icons.cancel_rounded;
    if (status == 'excused') return Icons.info_rounded;
    return Icons.fact_check_rounded;
  }

  String _statusText(String status) {
    if (status == 'present') return "present".tr;
    if (status == 'absent') return "absent".tr;
    if (status == 'excused') return "excused".tr;
    return status;
  }
}