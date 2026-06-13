import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/EmergencyController.dart';
import 'package:studants/models/EmergencyCase.dart';
import 'package:studants/views/EmergencyCreateView.dart';
import 'package:studants/views/EmergencyDetailView.dart';
import '../../utlis/app_colors.dart';

class EmergencyListView extends StatelessWidget {
  const EmergencyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('حالات الطوارئ'),
        backgroundColor: AppColors.darkPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.emergencyCases.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mauve));
        }

        if (controller.emergencyCases.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 72, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('لا توجد بلاغات طوارئ سابقة', 
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchEmergencyCases(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.emergencyCases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.emergencyCases[index];
              return _buildCaseCard(item, controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const EmergencyCreateView()),
        backgroundColor: AppColors.darkPurple,
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: const Text('بلاغ جديد', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCaseCard(EmergencyCase item, EmergencyController controller) {
    final isHigh = item.severity == 'high';
    final statusColor = item.status == 'resolved' ? Colors.green : Colors.orange;
    final statusText = item.status == 'resolved' ? 'تم الحل' : 'قيد المعالجة';

    return GestureDetector(
      onTap: () {
        controller.selectedCase.value = item;
        Get.to(() => const EmergencyDetailView());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHigh ? Colors.redAccent.withOpacity(0.3) : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isHigh ? Colors.red.shade50 : AppColors.softLavender,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isHigh ? Icons.warning_amber_rounded : Icons.info_outline,
                color: isHigh ? Colors.redAccent : AppColors.mauve,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🕐 ${item.createdAt.toString().substring(0, 16)}',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}