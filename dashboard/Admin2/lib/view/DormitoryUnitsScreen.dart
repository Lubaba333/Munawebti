import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/DormitoryUnitController.dart';
import 'UnitDetailsView.dart';

class DormitoryUnitView extends StatelessWidget {
  final controller = Get.put(DormitoryUnitController());
  final TextEditingController nameController = TextEditingController();

  // تأكدي أن الصورة موجودة في الـ assets أو استخدمي رابط URL صالح
  final String unitImage = "assets/images/house.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      appBar: AppBar(
        title: const Text("وحدات السكن"),
        backgroundColor: const Color(0xFF5A0891),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchUnits(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.units.isEmpty) {
            return const Center(child: Text("لا توجد وحدات حالياً"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,      // 4 كروت في السطر
              mainAxisSpacing: 4,     // تقليل المسافة الرأسية بين الكروت
              crossAxisSpacing: 4,    // تقليل المسافة الأفقية بين الكروت
              childAspectRatio: 0.85, // 🔥 كلما زاد هذا الرقم، صغر طول الكارد (جربي 0.8 إلى 0.9)
            ),
            itemCount: controller.units.length,
            itemBuilder: (context, index) {
              final unit = controller.units[index];

              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 250 + (index * 50)),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.85 + (0.15 * value),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand, // 🔥 يجعل الـ Stack يملأ مساحة الكرت بالكامل
                    children: [
                      // 1️⃣ المحتوى الأساسي (الصورة والاسم)
                      InkWell(
                        onTap: () {
                          controller.showUnit(unit.id);
                          Get.to(() => UnitDetailsView(), arguments: unit);
                        },
                        child: Column(
                          children: [
                            // 🖼️ جزء الصورة
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  unitImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.home, size: 30, color: Colors.grey),
                                ),
                              ),
                            ),
                            // 🟣 جزء الاسم
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF5A0891), Color(0xFF8E24AA)],
                                  ),
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  unit.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9, // خط صغير ليتناسب مع العرض الصغير
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ❌ زر الحذف (أعلى اليسار)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: GestureDetector(
                          onTap: () => controller.deleteUnit(unit.id),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 10, color: Colors.white),
                          ),
                        ),
                      ),

                      // ✏️ زر التعديل (أعلى اليمين)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _openDialog(isEdit: true, unit: unit),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, size: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5A0891),
        onPressed: () => _openDialog(isEdit: false),
        child: const Icon(Icons.add),
      ),
    );
  }

  // دالة الـ Dialog تبقى كما هي...
  void _openDialog({required bool isEdit, dynamic unit}) {
    if (isEdit) nameController.text = unit.name;
    else nameController.clear();

    Get.defaultDialog(
      title: isEdit ? "تعديل الوحدة" : "إضافة وحدة",
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(hintText: "اسم الوحدة"),
      ),
      textConfirm: isEdit ? "تعديل" : "إضافة",
      onConfirm: () {
        if (isEdit) controller.updateUnit(unit.id, nameController.text);
        else controller.addUnit(nameController.text);
        Get.back();
      },
    );
  }
}