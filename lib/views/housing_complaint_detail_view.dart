import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/housing_complaint_controller.dart';
import '../utlis/app_colors.dart';

class HousingComplaintDetailView extends StatelessWidget {
  const HousingComplaintDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HousingComplaintController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),

      appBar: AppBar(
        title: const Text("تفاصيل الشكوى"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
      ),

     body: RefreshIndicator(
  onRefresh: () async {
    final controller = Get.find<HousingComplaintController>();

    if (controller.selectedComplaint.value != null) {
      await controller.fetchComplaintDetails(
        controller.selectedComplaint.value!.id,
      );
    }
  },

 
      
      child: Stack(
        children: [
          _background(),

          Obx(() {
            final item = controller.selectedComplaint.value;

            if (item == null || controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            /// 📅 تحويل التاريخ
            DateTime date;
            try {
              date = DateTime.parse(item.createdAt);
            } catch (_) {
              date = DateTime.now();
            }

            final formattedDate =
                DateFormat('yyyy-MM-dd  •  HH:mm').format(date);

            final isResolved = item.status == 'resolved';

            return Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🟣 الحالة الكبيرة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isResolved
                            ? [Colors.green, Colors.green.shade300]
                            : [Colors.orange, Colors.orange.shade300],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isResolved
                              ? Icons.check_circle
                              : Icons.hourglass_bottom,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isResolved
                              ? "تم حل الشكوى"
                              : "قيد المعالجة",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📝 العنوان
                  _infoCard(
                    "العنوان",
                    item.title,
                    icon: Icons.title,
                  ),

                  const SizedBox(height: 12),

                  /// 📄 الوصف
                  _infoCard(
                    "الوصف",
                    item.description,
                    icon: Icons.description,
                    multiline: true,
                  ),

                  const SizedBox(height: 12),

                  /// 📅 التاريخ
                  _infoCard(
                    "تاريخ الإنشاء",
                    formattedDate,
                    icon: Icons.access_time,
                  ),

                  const Spacer(),

                  /// 💡 ملاحظة
                  if (!isResolved)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "سيتم معالجة شكواك قريباً من قبل الإدارة",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
     ) );
  }

  /// 🔥 كارد معلومات
  Widget _infoCard(
    String label,
    String value, {
    required IconData icon,
    bool multiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.mauve),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: multiline ? 5 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🌸 الخلفية
  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(200, AppColors.lightPink.withOpacity(0.5)),
        ),
        Positioned(
          top: 120,
          right: -60,
          child: _circle(180, AppColors.mauve.withOpacity(0.4)),
        ),
        Positioned(
          bottom: -80,
          left: 60,
          child: _circle(220, AppColors.deepPurple.withOpacity(0.3)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}