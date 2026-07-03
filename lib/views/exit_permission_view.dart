// lib/views/exit_permission_view.dart
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildForm()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 10),
          Text(
            "Exit Permission".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
  icon: Icons.info_outline,  // ✅ موجود
  // أو استخدم Icons.description
),
            
            const SizedBox(height: 30),
            
            Obx(() => GradientButton(
              text: controller.isLoading.value ? "Submitting...".tr : "Submit Request".tr,
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
            )),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (titleCtrl.text.isEmpty) {
      Get.snackbar("Error".tr, "Please enter title".tr,
        backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (dateCtrl.text.isEmpty) {
      Get.snackbar("Error".tr, "Please enter exit date".tr,
        backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }
}