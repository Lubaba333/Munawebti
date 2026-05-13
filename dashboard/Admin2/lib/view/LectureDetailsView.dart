import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LocationController.dart';
import '../model/LectureModel.dart';
import '../widgets/AppColors.dart';
import 'LocationGroupsScreen.dart';

class LectureDetailsView extends StatelessWidget {
  final locationController = Get.put(LocationController());

  LectureDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final LectureModel lecture = Get.arguments;



    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("بيانات المحاضرة"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(lecture),
            const SizedBox(height: 20),
            _infoTile("المادة", lecture.subject?.name ?? "غير محدد", Icons.subject),
            _infoTile("المدرس", lecture.teacherName, Icons.person),
            _infoTile("الوقت", "${lecture.fromHour.substring(0, 5)} - ${lecture.toHour.substring(0, 5)}", Icons.timer),
            _infoTile("اليوم", lecture.day, Icons.today),
            const SizedBox(height: 20),
            const Divider(),
            _buildLocationSection(context, lecture.id),
          ],
        ),
      ),
    );
  }

  // الجزء العلوي (تم إصلاحه)
  Widget _buildHeader(LectureModel lecture) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(lecture.isPractical ? Icons.biotech : Icons.menu_book, size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        Text(lecture.isPractical ? "قسم عملي (Lab)" : "قسم نظري (Lecture)",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ويدجت عرض المعلومات (تم إصلاحه)
  Widget _infoTile(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, int lectureId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("موقع المحاضرة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => locationController.currentLocation.value == null
                ? IconButton(icon: const Icon(Icons.add_location_alt, color: Colors.green), onPressed: () => _showLocationDialog(context, lectureId))
                : const SizedBox()),
          ],
        ),
        Obx(() {
          if (locationController.isLoading.value) return const LinearProgressIndicator();
          final loc = locationController.currentLocation.value;
          if (loc == null) return const Text("لا يوجد موقع محدد حالياً");

          return Card(
            child: ListTile(
              onTap: () => Get.to(() => LocationGroupsScreen(), arguments: loc),
              leading: const Icon(Icons.location_on, color: AppColors.primary),
              title: Text(loc.labName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showLocationDialog(context, lectureId, locationId: loc.id, currentName: loc.labName)),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => locationController.deleteLocation(loc.id, lectureId)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showLocationDialog(BuildContext context, int lectureId, {int? locationId, String? currentName}) {
    final nameController = TextEditingController(text: currentName);
    Get.defaultDialog(
      title: currentName == null ? "تحديد الموقع" : "تعديل الموقع",
      content: TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم القاعة/المخبر")),
      onConfirm: () {
        if (currentName == null) {
          locationController.createLocation(lectureId, nameController.text);
        } else {
          locationController.updateLocation(locationId!, lectureId, nameController.text);
        }
        Get.back();
      },
    );
  }
}