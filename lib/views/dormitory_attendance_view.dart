import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dormitory_attendance_controller.dart';
import '../utlis/app_colors.dart';
import 'dormitory_attendance_detail_view.dart';

class DormitoryAttendanceView extends StatelessWidget {
  DormitoryAttendanceView({super.key});

  final controller = Get.put(DormitoryAttendanceController());

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
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
                      return _emptyState();
                    }

                    return RefreshIndicator(
                      color: AppColors.mauve,
                      onRefresh: controller.fetchAttendance,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                        itemCount: controller.attendanceList.length,
                        itemBuilder: (_, i) {
                          final item = controller.attendanceList[i];
                          return _card(item);
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
                  "dormitory_attendance".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "dormitory_attendance_subtitle".tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(dynamic item) {
    final isPresent = item.status == 'present';
    final statusColor = isPresent ? Colors.green : Colors.red;
    final statusText =
        isPresent ? "inside_dormitory".tr : "outside_dormitory".tr;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withOpacity(.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.08),
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
              isPresent ? Icons.home_rounded : Icons.logout_rounded,
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
                  statusText,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.createdAt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await controller.fetchAttendanceDetails(item.id);
              Get.to(() => const DormitoryAttendanceDetailView());
            },
            child: Text("details".tr),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        "no_dormitory_attendance_records".tr,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}