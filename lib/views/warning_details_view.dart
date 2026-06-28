import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/warning_details_controller.dart';
import '../utlis/app_colors.dart';

class WarningDetailsView extends StatelessWidget {
  final int id;

  WarningDetailsView({super.key, required this.id});

  late final WarningDetailsController controller =
      Get.put(WarningDetailsController(id), tag: id.toString());

  static const warningOrange = Color(0xFFF59E0B);

  String _text(dynamic value) {
    if (value == null) return "غير محدد";
    if (value.toString().isEmpty) return "غير محدد";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    final warning = controller.warning;

                    if (warning.isEmpty) {
                      return const Center(
                        child: Text("لا توجد تفاصيل"),
                      );
                    }

                    final creator = warning['creator'];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _certificateHeader(warning),
                          const SizedBox(height: 22),
                          _certificateItem(
                            icon: Icons.description_rounded,
                            title: "الوصف",
                            value: _text(warning['description']),
                          ),
                          _certificateItem(
                            icon: Icons.calendar_month_rounded,
                            title: "تاريخ التنبيه",
                            value: _text(warning['warning_date']),
                          ),
                          _certificateItem(
                            icon: Icons.gavel_rounded,
                            title: "العقوبة المحتملة",
                            value: _text(warning['possible_penalty']),
                          ),
                          _certificateItem(
                            icon: Icons.person_rounded,
                            title: "المشرف",
                            value: creator is Map
                                ? _text(creator['full_name'])
                                : "غير محدد",
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
              Icons.warning_amber_rounded,
              color: Color(0xFFFFD54F),
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تفاصيل التنبيه",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "عرض معلومات التنبيه كاملة",
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

  Widget _certificateHeader(Map warning) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: warningOrange.withOpacity(.13),
            shape: BoxShape.circle,
            border: Border.all(
              color: warningOrange.withOpacity(.30),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: warningOrange,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "تنبيه رسمي",
          style: TextStyle(
            color: AppColors.darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _text(warning['title']),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.darkPurple,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            height: 1.35,
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
                color: warningOrange,
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