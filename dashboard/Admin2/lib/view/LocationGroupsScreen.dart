import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LocationController.dart';
import '../model/LectureLocationModel.dart';
import '../widgets/AppColors.dart';

class LocationGroupsScreen extends StatelessWidget {
  // العثور على الكنترولر المحقون مسبقاً
  final controller = Get.find<LocationController>();

  LocationGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استقبال كائن الموقع الممرر من الواجهة السابقة
    final LectureLocationModel locationData = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("مجموعات ${locationData.labName}"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // عرض كرت معلومات الموقع العلوي
          _buildLocationHeader(locationData),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "الفئات المسندة حالياً:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // قائمة الفئات المسندة مع التحديث التلقائي
          Expanded(
            child: Obx(() {
              final loc = controller.currentLocation.value;

              // في حال كان الموقع فارغاً أو لا توجد مجموعات
              if (loc == null || loc.groupAssignments.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: loc.groupAssignments.length,
                itemBuilder: (context, index) {
                  final item = loc.groupAssignments[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.group, color: Colors.white, size: 20),
                      ),
                      // الوصول الصحيح للبيانات عبر item.group
                      title: Text(
                        "فئة: ${item.group.groupNumber}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "السنة: ${item.group.section.year} - القسم: ${item.group.section.sectionNumber}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _confirmRemove(context, loc.id, item.groupId, locationData.lectureId),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // زر الإسناد السفلي
          _buildAddButton(context, locationData),
        ],
      ),
    );
  }

  // كرت هيدر الموقع
  Widget _buildLocationHeader(LectureLocationModel loc) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("إدارة قاعة / مختبر", style: TextStyle(color: Colors.white70, fontSize: 14)),
          Text(
            loc.labName,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // حالة القائمة الفارغة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text("لا توجد فئات مسندة لهذا الموقع", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // زر الإضافة
  Widget _buildAddButton(BuildContext context, LectureLocationModel loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: () => _showAssignDialog(loc.id, loc.lectureId),
        icon: const Icon(Icons.add_link),
        label: const Text("إسناد فئة (Group) جديدة"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // دايالوغ تأكيد الحذف
  void _confirmRemove(BuildContext context, int locId, int groupId, int lectureId) {
    Get.defaultDialog(
      title: "إزالة فئة",
      middleText: "هل أنت متأكد من إزالة هذه الفئة من الموقع؟",
      textConfirm: "إزالة",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.removeGroupFromLocation(locId, groupId, lectureId);
        Get.back();
      },
    );
  }

  // دايالوغ إسناد فئة جديدة
  void _showAssignDialog(int locationId, int lectureId) {
    final idCtrl = TextEditingController();
    Get.defaultDialog(
      title: "إسناد فئة",
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: idCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "أدخل معرف الفئة (Group ID)",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      textConfirm: "تأكيد الإسناد",
      onConfirm: () {
        if (idCtrl.text.isNotEmpty) {
          controller.assignGroup(locationId, int.parse(idCtrl.text), lectureId);
          Get.back();
        }
      },
    );
  }
}