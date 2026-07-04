import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/EmergencyController.dart';
import 'package:studants/models/EmergencyCase.dart';
import 'package:studants/views/EmergencyCreateView.dart';
import 'package:studants/views/EmergencyDetailView.dart';
import '../../utlis/app_colors.dart';

class EmergencyListView extends StatelessWidget {
  final bool showBackButton;

  const EmergencyListView({
    super.key,
    this.showBackButton = true,
  });

  static const emergencyRed = Color(0xFFD84A4A);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const EmergencyCreateView()),
        backgroundColor: emergencyRed,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: Text(
          'new_report'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.emergencyCases.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    if (controller.emergencyCases.isEmpty) {
                      return _emptyState(context);
                    }

                    return RefreshIndicator(
                      color: AppColors.mauve,
                      onRefresh: () => controller.fetchEmergencyCases(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
                        itemCount: controller.emergencyCases.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = controller.emergencyCases[index];
                          return _buildCaseCard(context, item, controller);
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
          if (showBackButton)
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
          if (showBackButton) const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(.25),
              ),
            ),
            child: const Icon(
              Icons.emergency_share_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'emergency_cases'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'emergency_cases_subtitle'.tr,
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

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Colors.white.withOpacity(.08)
                  : AppColors.softLavender,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 52,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'no_emergency_reports'.tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'emergency_reports_hint'.tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(
    BuildContext context,
    EmergencyCase item,
    EmergencyController controller,
  ) {
    final isHigh = item.severity == 'high';
    final isResolved = item.status == 'resolved';

    final statusColor = isResolved ? Colors.green : Colors.orange;
    final statusText = isResolved ? 'resolved'.tr : 'processing'.tr;

    final severityColor = isHigh ? emergencyRed : AppColors.mauve;

    return GestureDetector(
      onTap: () {
        controller.selectedCase.value = item;
        Get.to(() => const EmergencyDetailView());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: severityColor.withOpacity(.20),
          ),
          boxShadow: [
            BoxShadow(
              color: Get.isDarkMode
                  ? Colors.black.withOpacity(.20)
                  : AppColors.deepPurple.withOpacity(.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isHigh
                        ? emergencyRed.withOpacity(.10)
                        : Get.isDarkMode
                            ? Colors.white.withOpacity(.08)
                            : AppColors.softLavender,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isHigh
                        ? Icons.warning_amber_rounded
                        : Icons.info_outline_rounded,
                    color: severityColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _smallInfoChip(
                  icon: Icons.circle,
                  text: statusText,
                  color: statusColor,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    controller.selectedCase.value = item;
                    Get.to(() => const EmergencyDetailView());
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text('details'.tr),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Get.isDarkMode ? Colors.white : AppColors.darkPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}