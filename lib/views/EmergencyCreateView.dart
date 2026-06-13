import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/EmergencyController.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/gradient_button.dart';
import '../../utlis/app_colors.dart';

class EmergencyCreateView extends StatelessWidget {
  const EmergencyCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmergencyController>();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    var selectedSeverity = 'medium'.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال بلاغ طوارئ'),
        backgroundColor: AppColors.darkPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: titleCtrl,
              hint: 'عنوان الطوارئ (مثال: عطل كهربائي)',
              icon: Icons.title,
            ),
            CustomTextField(
              controller: descCtrl,
              hint: 'وصف تفصيلي للموقف...',
              icon: Icons.description,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
           
            Obx(() => GradientButton(
              text: controller.isLoading.value ? 'جاري الإرسال...' : 'إرسال البلاغ',
              isLoading: controller.isLoading.value,
              onTap: () {
                if (titleCtrl.text.trim().isEmpty || descCtrl.text.trim().isEmpty) {
                  Get.snackbar('تنبيه', 'يرجى ملء جميع الحقول', snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                controller.submitEmergencyCase(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  severity: selectedSeverity.value,
                );
              },
            )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم إشعار الإدارة فوراً. في الحالات الحرجة، يرجى التواصل مباشرة مع المشرفة.',
                      style: TextStyle(color: Colors.orange.shade800, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}