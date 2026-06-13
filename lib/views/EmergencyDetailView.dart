import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studants/controllers/EmergencyController.dart';
import '../../utlis/app_colors.dart';

class EmergencyDetailView extends StatelessWidget {
  const EmergencyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmergencyController>();

    return Scaffold(
      backgroundColor: AppColors.softLavender,
      appBar: AppBar(
        title: const Text('تفاصيل البلاغ'),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value ||
            controller.selectedCase.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          );
        }

        final item = controller.selectedCase.value!;

        DateTime createdAtDateTime;
        try {
          createdAtDateTime = DateTime.parse(item.createdAt);
        } catch (_) {
          createdAtDateTime = DateTime.now();
        }

        final dateStr =
            DateFormat('yyyy-MM-dd HH:mm').format(createdAtDateTime);

        final isResolved = item.status == 'resolved';

        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _buildInfoCard(
                'العنوان',
                item.title,
                icon: Icons.title_rounded,
              ),

              const SizedBox(height: 12),

              _buildInfoCard(
                'الوصف',
                item.description,
                icon: Icons.description_rounded,
                isMultiline: true,
              ),

              const SizedBox(height: 12),

              _buildInfoCard(
                'الحالة',
                isResolved ? 'تم الحل' : 'قيد المعالجة',
                icon: isResolved
                    ? Icons.check_circle_rounded
                    : Icons.hourglass_empty_rounded,
                valueColor: isResolved ? Colors.green : Colors.orange,
              ),

              const SizedBox(height: 14),

              _dateCard(dateStr),

              const Spacer(),

              if (!isResolved) _pendingNotice(),
            ],
          ),
        );
      }),
    );
  }

  Widget _dateCard(String dateStr) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mauve.withOpacity(.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: AppColors.darkPurple,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'تاريخ الإنشاء: $dateStr',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _pendingNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.orange.shade700, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'بلاغك قيد المراجعة من قبل الإدارة. سيتم التواصل معك فور توفر تحديث.',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value, {
    bool isMultiline = false,
    Color? valueColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mauve.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.softLavender,
            child: Icon(
              icon,
              color: valueColor ?? AppColors.darkPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.darkPurple,
                  ),
                  maxLines: isMultiline ? 6 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}