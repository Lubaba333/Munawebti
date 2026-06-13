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
      appBar: AppBar(
        title: const Text('تفاصيل البلاغ'),
        backgroundColor: AppColors.darkPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.selectedCase.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mauve));
        }

        final item = controller.selectedCase.value!;
        
        // ✅ الحل: تحويل الـ String إلى DateTime قبل التنسيق
        DateTime createdAtDateTime;
        try {
          createdAtDateTime = DateTime.parse(item.createdAt);
        } catch (_) {
          createdAtDateTime = DateTime.now(); // fallback إذا فشل التحليل
        }
        final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(createdAtDateTime);
        
        final isHigh = item.severity == 'high';

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('العنوان', item.title),
              const SizedBox(height: 12),
              _buildInfoCard('الوصف', item.description, isMultiline: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'الحالة', 
                      item.status == 'resolved' ? '✅ تم الحل' : '⏳ قيد المعالجة',
                      valueColor: item.status == 'resolved' ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'تاريخ الإنشاء: $dateStr', 
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (item.status != 'resolved')
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.hourglass_empty, color: Colors.orange, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'بلاغك قيد المراجعة من قبل الإدارة. سيتم التواصل معك فور توفر تحديث.',
                          style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // ✅ دالة مساعدة لتحويل قيمة severity إلى نص عربي
 

  Widget _buildInfoCard(String label, String value, {
    bool isMultiline = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
            maxLines: isMultiline ? 5 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}