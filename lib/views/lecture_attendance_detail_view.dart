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
      backgroundColor: AppColors.softLavender,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
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
                            title: item.subjectName,
                            status: item.status,
                          ),
                          const SizedBox(height: 22),
                          _certificateItem(
                            icon: Icons.fact_check_rounded,
                            title: "الحالة",
                            value: _statusText(item.status),
                          ),
                          _certificateItem(
                            icon: Icons.calendar_month_rounded,
                            title: "تاريخ الحضور",
                            value: item.attendanceDate,
                          ),
                          _certificateItem(
                            icon: Icons.person_rounded,
                            title: "الدكتور",
                            value: item.teacherName,
                          ),
                          _certificateItem(
                            icon: Icons.access_time_rounded,
                            title: "الوقت",
                            value: "${item.fromHour} - ${item.toHour}",
                          ),
                          _certificateItem(
                            icon: Icons.today_rounded,
                            title: "اليوم",
                            value: item.day,
                          ),
                          _certificateItem(
                            icon: Icons.location_on_rounded,
                            title: "المكان",
                            value: item.labName,
                          ),
                          _certificateItem(
                            icon: Icons.groups_rounded,
                            title: "الفئة",
                            value: item.groupNumber,
                          ),
                          _certificateItem(
                            icon: Icons.account_tree_rounded,
                            title: "الشعبة",
                            value: item.branch,
                          ),
                          _certificateItem(
                            icon: Icons.menu_book_rounded,
                            title: "نوع المحاضرة",
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تفاصيل الحضور",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "عرض سجل حضور المحاضرة",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certificateHeader({
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
        const Text(
          "سجل حضور محاضرة",
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.darkPurple,
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
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  Widget _certificateItem({
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
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? "غير محدد" : value,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.grey.shade200),
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
    if (status == 'present') return "حاضر";
    if (status == 'absent') return "غائب";
    if (status == 'excused') return "معذور";
    return status;
  }
}