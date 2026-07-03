import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/housing_complaint_controller.dart';
import '../utlis/app_colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/gradient_button.dart';

class HousingComplaintCreateView extends StatelessWidget {
  HousingComplaintCreateView({super.key});

  final HousingComplaintController controller =
      Get.find<HousingComplaintController>();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(38),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: AppColors.softLavender,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Icon(
                            Icons.campaign_outlined,
                            color: AppColors.darkPurple,
                            size: 46,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "new_housing_complaint".tr,
                          style: const TextStyle(
                            color: AppColors.darkPurple,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "housing_complaint_create_subtitle".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),
                        CustomTextField(
                          controller: titleController,
                          hint: "complaint_title".tr,
                          icon: Icons.title,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: descController,
                          hint: "complaint_description".tr,
                          icon: Icons.description_outlined,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 28),
                        Obx(
                          () => GradientButton(
                            text: controller.isLoading.value
                                ? "sending".tr
                                : "submit_complaint".tr,
                            isLoading: controller.isLoading.value,
                            onTap: () {
                              if (titleController.text.trim().isEmpty ||
                                  descController.text.trim().isEmpty) {
                                Get.snackbar(
                                  "warning".tr,
                                  "fill_title_and_description".tr,
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }

                              controller.createComplaint(
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.softLavender.withOpacity(.55),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.darkPurple,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "housing_complaint_notice".tr,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12.5,
                                    height: 1.4,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
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
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "create_complaint".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}