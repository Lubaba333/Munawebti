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
        title: Text('emergency_report'.tr),
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
                    Text(
                      'emergency'.tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC62828),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'emergency_create_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: titleCtrl,
                      hint: 'emergency_title'.tr,
                      icon: Icons.title,
                    ),
                    CustomTextField(
                      controller: descCtrl,
                      hint: 'emergency_description'.tr,
                      icon: Icons.description,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 25),
                    Obx(
                      () => GradientButton(
                        text: controller.isLoading.value
                            ? 'sending'.tr
                            : 'send_report'.tr,
                        isLoading: controller.isLoading.value,
                        onTap: () {
                          if (titleCtrl.text.trim().isEmpty ||
                              descCtrl.text.trim().isEmpty) {
                            Get.snackbar(
                              'warning'.tr,
                              'fill_all_fields'.tr,
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
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'emergency_notice'.tr,
                        style: const TextStyle(
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