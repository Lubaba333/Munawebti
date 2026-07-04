import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/models/request_model.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';

class ExitPermissionView extends StatelessWidget {
  ExitPermissionView({super.key});

  final RequestController controller = Get.put(RequestController());

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final fromCtrl = TextEditingController();
  final toCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.currentGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildForm(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Exit Permission".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.22)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CustomTextField(
              controller: titleCtrl,
              hint: "Request Title".tr,
              icon: Icons.title,
            ),
            CustomTextField(
              controller: descCtrl,
              hint: "Description".tr,
              icon: Icons.description,
            ),
            CustomTextField(
              controller: dateCtrl,
              hint: "Exit Date (YYYY-MM-DD)".tr,
              icon: Icons.calendar_today,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: fromCtrl,
                    hint: "From (HH:MM)".tr,
                    icon: Icons.access_time,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextField(
                    controller: toCtrl,
                    hint: "To (HH:MM)".tr,
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            CustomTextField(
              controller: reasonCtrl,
              hint: "Reason for exit".tr,
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 30),
            Obx(
              () => GradientButton(
                text: controller.isLoading.value
                    ? "Submitting...".tr
                    : "Submit Request".tr,
                isLoading: controller.isLoading.value,
                onTap: () {
                  if (_validateForm()) {
                    final request = ExitPermissionRequest(
                      title: titleCtrl.text,
                      description: descCtrl.text,
                      exitDate: dateCtrl.text,
                      fromHour: fromCtrl.text,
                      toHour: toCtrl.text,
                      reason: reasonCtrl.text,
                    );
                    controller.createExitRequest(request);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (titleCtrl.text.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Please enter title".tr,
        backgroundColor:
            Get.isDarkMode ? const Color(0xFF8B1E2D) : Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (dateCtrl.text.isEmpty) {
      Get.snackbar(
        "Error".tr,
        "Please enter exit date".tr,
        backgroundColor:
            Get.isDarkMode ? const Color(0xFF8B1E2D) : Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}