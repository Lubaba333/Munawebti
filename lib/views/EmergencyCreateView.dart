import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/EmergencyController.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/gradient_button.dart';

class EmergencyCreateView extends StatefulWidget {
  const EmergencyCreateView({super.key});

  @override
  State<EmergencyCreateView> createState() => _EmergencyCreateViewState();
}

class _EmergencyCreateViewState extends State<EmergencyCreateView> {
  final EmergencyController controller = Get.find<EmergencyController>();

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final selectedSeverity = 'medium'.obs;

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFFFF2F2),
  appBar: AppBar(
    title: const Text('إرسال بلاغ طوارئ'),
    backgroundColor: const Color(0xFFD84A4A),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFD84A4A),
          Color(0xFFF4A6A6),
          Colors.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD84A4A).withOpacity(0.20),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFFFE6E6),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: Color(0xFFD84A4A),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'بلاغ طوارئ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'يرجى وصف الحالة بدقة ليتم التعامل معها بسرعة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),

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

                const SizedBox(height: 25),

                Obx(
                  () => GradientButton(
                    text: controller.isLoading.value
                        ? 'جاري الإرسال...'
                        : 'إرسال البلاغ',
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (titleCtrl.text.trim().isEmpty ||
                          descCtrl.text.trim().isEmpty) {
                        Get.snackbar(
                          'تنبيه',
                          'يرجى ملء جميع الحقول',
                          backgroundColor: const Color(0xFFD84A4A),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      controller.submitEmergencyCase(
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        severity: selectedSeverity.value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFCC80),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'سيتم إشعار الإدارة فوراً. في الحالات الحرجة يرجى التواصل مباشرة مع المشرفة.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}