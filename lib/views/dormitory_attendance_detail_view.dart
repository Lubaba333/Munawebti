import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dormitory_attendance_controller.dart';
import '../utlis/app_colors.dart';

class DormitoryAttendanceDetailView extends StatelessWidget {
  const DormitoryAttendanceDetailView({super.key});

  static const attendanceColor = AppColors.mauve;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DormitoryAttendanceController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     body: Container(
  decoration: BoxDecoration(
    gradient: AppColors.currentGradient,
  ),
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

                    final isPresent = item.status == 'present';

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _certificateHeader(
                            context,
                            isPresent: isPresent,
                            status: item.status,
                          ),
                          const SizedBox(height: 22),
                          _certificateItem(
                            context,
                            icon: isPresent
                                ? Icons.home_rounded
                                : Icons.logout_rounded,
                            title: "status".tr,
                            value: isPresent
                                ? "inside_dormitory".tr
                                : "outside_dormitory".tr,
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.access_time_rounded,
                            title: "date".tr,
                            value: item.createdAt,
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
              Icons.home_work_rounded,
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
                  "dormitory_attendance_details".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "view_attendance_record_details".tr,
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
    required bool isPresent,
    required String status,
  }) {
    final color = isPresent ? Colors.green : Colors.red;

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
            isPresent ? Icons.home_rounded : Icons.logout_rounded,
            color: color,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "dormitory_attendance_record".tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isPresent ? "inside_dormitory".tr : "outside_dormitory".tr,
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
            status == 'present'
                ? "present".tr
                : status == 'absent'
                    ? "absent".tr
                    : status,
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
}