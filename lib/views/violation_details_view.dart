import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/violation_details_controller.dart';
import '../utlis/app_colors.dart';

class ViolationDetailsView extends StatelessWidget {
  final int id;

  const ViolationDetailsView({super.key, required this.id});

  static const violationRed = Color(0xFFD84A4A);

  String _text(dynamic value) {
    if (value == null) return "not_specified".tr;
    if (value.toString().isEmpty) return "not_specified".tr;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ViolationDetailsController(id),
      tag: id.toString(),
    );

    final isDark = Get.isDarkMode;

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
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    final v = controller.violation;

                    if (v.isEmpty) {
                      return Center(
                        child: Text(
                          "no_details".tr,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final creator = v['creator'];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _certificateHeader(context, v),
                          const SizedBox(height: 22),
                          _certificateItem(
                            context,
                            icon: Icons.description_outlined,
                            title: "description".tr,
                            value: _text(v['description']),
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.category_rounded,
                            title: "violation_category".tr,
                            value: _text(v['category']),
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.calendar_month_rounded,
                            title: "violation_date".tr,
                            value: _text(v['violation_date']),
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.gavel_rounded,
                            title: "penalty".tr,
                            value: _text(v['penalty']),
                          ),
                          _certificateItem(
                            context,
                            icon: Icons.person_rounded,
                            title: "supervisor".tr,
                            value: creator is Map
                                ? _text(creator['full_name'])
                                : "not_specified".tr,
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
              Icons.gpp_bad_rounded,
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
                  "violation_details".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "violation_details_subtitle".tr,
                  style: const TextStyle(
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

  Widget _certificateHeader(BuildContext context, Map v) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: violationRed.withOpacity(.13),
            shape: BoxShape.circle,
            border: Border.all(
              color: violationRed.withOpacity(.30),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.gpp_bad_rounded,
            color: violationRed,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "official_violation".tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _text(v['title']),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            height: 1.35,
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
    final isDark = Get.isDarkMode;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: violationRed,
                size: 23,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.mauve : AppColors.darkPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
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