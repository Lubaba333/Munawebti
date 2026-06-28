import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/housing_complaint_controller.dart';
import '../utlis/app_colors.dart';

class HousingComplaintDetailView extends StatelessWidget {
  const HousingComplaintDetailView({super.key});

  static const complaintColor = AppColors.mauve;

  String _text(dynamic value) {
    if (value == null) return "غير محدد";
    if (value.toString().isEmpty) return "غير محدد";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HousingComplaintController>();

    return Scaffold(
      backgroundColor: AppColors.softLavender,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (controller.selectedComplaint.value != null) {
                        await controller.fetchComplaintDetails(
                          controller.selectedComplaint.value!.id,
                        );
                      }
                    },
                    child: Obx(() {
                      final item = controller.selectedComplaint.value;

                      if (item == null || controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mauve,
                          ),
                        );
                      }

                      DateTime date;
                      try {
                        date = DateTime.parse(item.createdAt);
                      } catch (_) {
                        date = DateTime.now();
                      }

                      final formattedDate =
                          DateFormat('yyyy-MM-dd  •  HH:mm').format(date);

                      final isResolved = item.status == 'resolved';

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            _certificateHeader(item, isResolved),
                            const SizedBox(height: 22),
                            _certificateItem(
                              icon: Icons.description_outlined,
                              title: "الوصف",
                              value: _text(item.description),
                            ),
                            _certificateItem(
                              icon: Icons.calendar_month_rounded,
                              title: "تاريخ الإنشاء",
                              value: formattedDate,
                            ),
                            _certificateItem(
                              icon: isResolved
                                  ? Icons.check_circle_rounded
                                  : Icons.hourglass_bottom_rounded,
                              title: "حالة الشكوى",
                              value: isResolved ? "تم حل الشكوى" : "قيد المعالجة",
                              showDivider: !isResolved,
                            ),
                            if (!isResolved)
                              _certificateItem(
                                icon: Icons.info_outline_rounded,
                                title: "ملاحظة",
                                value: "سيتم معالجة شكواك قريباً من قبل الإدارة",
                                showDivider: false,
                              ),
                          ],
                        ),
                      );
                    }),
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
              Icons.campaign_outlined,
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
                  "تفاصيل الشكوى",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "عرض معلومات الشكوى كاملة",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certificateHeader(dynamic item, bool isResolved) {
    final statusColor = isResolved ? Colors.green : Colors.orange;

    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: complaintColor.withOpacity(.13),
            shape: BoxShape.circle,
            border: Border.all(
              color: complaintColor.withOpacity(.30),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.campaign_outlined,
            color: complaintColor,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "شكوى سكن رسمية",
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _text(item.title),
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
            color: statusColor.withOpacity(.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isResolved ? "تم الحل" : "قيد المعالجة",
            style: TextStyle(
              color: statusColor,
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
              Icon(
                icon,
                color: complaintColor,
                size: 23,
              ),
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
                  value,
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
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}