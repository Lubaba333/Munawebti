import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/housing_complaint_controller.dart';
import '../utlis/app_colors.dart';
import 'housing_complaint_detail_view.dart';

class HousingComplaintsView extends StatelessWidget {
  HousingComplaintsView({super.key});

  final controller = Get.put(HousingComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),

      appBar: AppBar(
        title: const Text("شكاوى السكن"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
      ),

      /// 🔥 زر إضافة مع نص
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        backgroundColor: AppColors.mauve,
        icon: const Icon(Icons.add),
        label: const Text("إضافة شكوى"),
      ),

      body: Stack(
        children: [
          _background(),

          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.complaints.isEmpty) {
              return const Center(
                child: Text("لا يوجد شكاوى بعد"),
              );
            }

            return RefreshIndicator(
  onRefresh: () async {
    await controller.fetchComplaints(); // 🔥 تحديث البيانات
  },

  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(), // مهم!
    padding: const EdgeInsets.all(16),
    itemCount: controller.complaints.length,
    itemBuilder: (_, i) {
      final item = controller.complaints[i];
      return _buildComplaintCard(item);
    },
  ),
);
          }),
        ],
      ),
    );
  }

  /// 🎯 الكارد الاحترافي
  Widget _buildComplaintCard(complaint) {
    final isResolved = complaint.status == 'resolved';

    return GestureDetector(
      onTap: () async {
        await controller.fetchComplaintDetails(complaint.id);
        Get.to(() => const HousingComplaintDetailView());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isResolved
                ? Colors.green.withOpacity(0.3)
                : Colors.orange.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),

        child: Row(
          children: [

            /// 🔥 أيقونة الحالة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isResolved
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isResolved ? Icons.check_circle : Icons.pending,
                color: isResolved ? Colors.green : Colors.orange,
                size: 26,
              ),
            ),

            const SizedBox(width: 14),

            /// 📄 النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    complaint.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    complaint.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🟡 حالة
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isResolved
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isResolved ? "تم الحل" : "قيد المعالجة",
                      style: TextStyle(
                        color:
                            isResolved ? Colors.green : Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// ➕ Dialog إضافة
  void _showAddDialog() {
    final title = TextEditingController();
    final desc = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text("إضافة شكوى"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "العنوان"),
            ),
            TextField(
              controller: desc,
              decoration: const InputDecoration(labelText: "الوصف"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createComplaint(
                title: title.text,
                description: desc.text,
              );
            },
            child: const Text("إرسال"),
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