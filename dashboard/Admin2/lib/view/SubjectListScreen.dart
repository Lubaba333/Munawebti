import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/SubjectController.dart';
import '../model/SubjectModel.dart';
import '../widgets/AppColors.dart';
import 'LectureListScreen.dart';

class SubjectListScreen extends StatelessWidget {
  final controller = Get.put(SubjectController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSubjects();
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("المواد الدراسية"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubjectDialog(context),
        label: const Text("إضافة مادة"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.subjects.isEmpty) return const Center(child: Text("لا توجد مواد"));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.subjects.length,
          itemBuilder: (context, index) {
            final subject = controller.subjects[index];
            // ... داخل ListView.builder
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                onTap: () {
                  Get.to(
                        () => SubjectDetailsScreen(),
                    arguments: subject, // تمرير كائن المادة كاملاً للشاشة التالية
                    transition: Transition.cupertino, // حركة انتقال ناعمة
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.book, color: AppColors.primary),
                ),
                title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(subject.hasPractical ? "تحتوي على عملي" : "نظري فقط"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showSubjectDialog(context, model: subject),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(subject),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showSubjectDialog(BuildContext context, {SubjectModel? model}) {
    final nameController = TextEditingController(text: model?.name ?? "");
    var hasPractical = (model?.hasPractical ?? false).obs;

    Get.defaultDialog(
      title: model == null ? "إضافة مادة" : "تعديل مادة",
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "اسم المادة", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          Obx(() => CheckboxListTile(
            title: const Text("تتضمن قسم عملي؟"),
            value: hasPractical.value,
            onChanged: (val) => hasPractical.value = val!,
          )),
        ],
      ),
      textConfirm: model == null ? "إضافة" : "تحديث",
      onConfirm: () {
        if (nameController.text.isNotEmpty) {
          if (model == null) {
            controller.addSubject(nameController.text, hasPractical.value);
          } else {
            controller.updateSubject(model.id, nameController.text, hasPractical.value);
          }
        }
      },
    );
  }

  void _confirmDelete(SubjectModel subject) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد من حذف مادة ${subject.name}؟",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteSubject(subject.id);
        Get.back();
      },
    );
  }
}