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

  static const emergencyRed = Color(0xFFD84A4A);
  static const softEmergency = Color(0xFFFFB4A8);
  static const darkCard = Color(0xFF241826);
  static const darkNotice = Color(0xFF2D2330);

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

LinearGradient _emergencyGradient() {
  return Get.isDarkMode
      ? const LinearGradient(
          colors: [
            Color(0xFF8B1E2D),
            Color(0xFF5E1621),
            Color(0xFF3A1018),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [
            Color(0xFFD84A4A),
            Color(0xFFF4A6A6),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
}

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(
  title: Text('emergency_report'.tr),
  backgroundColor: Get.isDarkMode
      ? const Color(0xFF8B1E2D) // نفس أول لون بالتدرج
      : emergencyRed,
  foregroundColor: Colors.white,
  elevation: 0,
  scrolledUnderElevation: 0,
),
      body: Container(
  width: double.infinity,
  height: double.infinity,
  decoration: BoxDecoration(
    gradient: _emergencyGradient(),
  ),
  child: SafeArea(
    top: false,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      child: Column(
        children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? darkCard.withOpacity(.96)
                        : Colors.white.withOpacity(.95),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? softEmergency.withOpacity(.12)
                          : Colors.white.withOpacity(.40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(.28)
                            : emergencyRed.withOpacity(.20),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: isDark
                            ? softEmergency.withOpacity(.16)
                            : const Color(0xFFFFE6E6),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 50,
                          color: isDark ? softEmergency : emergencyRed,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'emergency'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? softEmergency
                              : const Color(0xFFC62828),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'emergency_create_subtitle'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
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
                                backgroundColor:
                                    isDark ? const Color(0xFF4A244F) : emergencyRed,
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
                    color: isDark ? darkNotice : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? softEmergency.withOpacity(.25)
                          : const Color(0xFFFFCC80),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark ? softEmergency : Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'emergency_notice'.tr,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
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
      ),
    );
  }
}