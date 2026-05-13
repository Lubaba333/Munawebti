import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LectureController.dart';
import '../model/SubjectModel.dart';
import '../model/LectureModel.dart';
import '../widgets/AppColors.dart';
import 'LectureDetailsView.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final lectureController = Get.put(LectureController());

  SubjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استقبال المادة (يحتوي على الـ ID والاسم)
    final SubjectModel subject = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      lectureController.fetchLectures();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(subject.name), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLectureForm(context, subject.id),
        label: const Text("إضافة موعد"),
        icon: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. معلومات المادة (Header)
          SliverToBoxAdapter(
            child: _buildSubjectInfoCard(subject),
          ),

          // 2. عنوان قسم المحاضرات
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text("جدول محاضرات المادة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          // 3. قائمة المحاضرات مع (حذف / تعديل / انتقال للعرض)
          Obx(() {
            if (lectureController.isLoading.value) {
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            }

            var filteredDays = _getFilteredLectures(subject.id);

            if (filteredDays.isEmpty) {
              return const SliverFillRemaining(
                  child: Center(child: Text("لا توجد مواعيد مضافة")));
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  String day = filteredDays.keys.elementAt(index);
                  return _buildDayGroup(context, day, filteredDays[day]!);
                },
                childCount: filteredDays.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- كروت معلومات المادة ---
  Widget _buildSubjectInfoCard(SubjectModel subject) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("معلومات المادة", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              Text("الحالة: ${subject.hasPractical ? "نظري + عملي" : "نظري فقط"}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  // --- مجموعات الأيام والمحاضرات ---
  Widget _buildDayGroup(BuildContext context, String day, List<LectureModel> lectures) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const Divider(),
          ...lectures.map((l) => Card(
            child: ListTile(
              // الانتقال لواجهة العرض (الشو)
              onTap: () => Get.to(() => LectureDetailsView(), arguments: l),
              title: Text(l.isPractical ? "عملي" : "نظري"),
              subtitle: Text("${l.fromHour.substring(0,5)} - ${l.toHour.substring(0,5)}\nد. ${l.teacherName}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // التعديل
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showLectureForm(context, l.subjectId, model: l),
                  ),
                  // الحذف
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(l.id),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  // --- فورم الإضافة والتعديل ---
  void _showLectureForm(BuildContext context, int subjectId, {LectureModel? model}) {
    final teacherController = TextEditingController(text: model?.teacherName ?? "");
    var selectedDay = (model?.day ?? "Monday").obs;
    var fromTime = (model?.fromHour.substring(0, 5) ?? "08:00").obs;
    var toTime = (model?.toHour.substring(0, 5) ?? "10:00").obs;
    var isPractical = (model?.isPractical ?? false).obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(model == null ? "إضافة محاضرة" : "تعديل محاضرة", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(controller: teacherController, decoration: const InputDecoration(labelText: "اسم المدرس", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                value: selectedDay.value,
                items: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                    .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => selectedDay.value = v!,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Obx(() => ListTile(title: const Text("من"), subtitle: Text(fromTime.value)))),
                  Expanded(child: Obx(() => ListTile(title: const Text("إلى"), subtitle: Text(toTime.value)))),
                ],
              ),
              Obx(() => CheckboxListTile(title: const Text("عملي؟"), value: isPractical.value, onChanged: (v) => isPractical.value = v!)),
              ElevatedButton(
                onPressed: () {
                  var data = {
                    "subject_id": subjectId,
                    "day": selectedDay.value,
                    "from_hour": fromTime.value,
                    "to_hour": toTime.value,
                    "teacher_name": teacherController.text,
                    "is_practical": isPractical.value,
                    "year": 1, "specialization": "Computer Science", "branch": "A"
                  };
                  model == null ? lectureController.addLecture(data) : lectureController.updateLecture(model.id, data);
                },
                child: Text(model == null ? "حفظ" : "تحديث"),
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDelete(int id) {
    Get.defaultDialog(title: "حذف", middleText: "متأكد؟", onConfirm: () {
      lectureController.deleteLecture(id);
      Get.back();
    });
  }

  Map<String, List<LectureModel>> _getFilteredLectures(int subjectId) {
    Map<String, List<LectureModel>> filtered = {};
    lectureController.lecturesByDay.forEach((day, list) {
      var matches = list.where((l) => l.subjectId == subjectId).toList();
      if (matches.isNotEmpty) filtered[day] = matches;
    });
    return filtered;
  }
}