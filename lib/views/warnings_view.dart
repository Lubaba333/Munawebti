import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/warning_controller.dart';
import '../utlis/app_colors.dart';
import 'warning_details_view.dart';

class WarningsView extends StatelessWidget {
  WarningsView({super.key});

  final controller = Get.put(WarningController());

  static const warningOrange = Color(0xFFF59E0B);

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
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    if (controller.warnings.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                      itemCount: controller.warnings.length,
                      itemBuilder: (context, index) {
                        final warning = controller.warnings[index];
                        return _buildCard(warning);
                      },
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
                  "تنبيهاتي",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "راجعي التنبيهات الموجهة إليك",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: warningOrange,
              size: 54,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "لا توجد تنبيهات",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "لا يوجد أي تنبيه مسجل حالياً",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: warningOrange.withOpacity(.25)),
        boxShadow: [
          BoxShadow(
            color: warningOrange.withOpacity(.10),
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
              color: warningOrange.withOpacity(.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: warningOrange,
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 15,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        warning.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Get.to(() => WarningDetailsView(id: warning.id));
            },
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text("تفاصيل"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.darkPurple,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}