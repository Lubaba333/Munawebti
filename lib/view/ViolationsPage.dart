import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ProfileController.dart';

class ViolationsPage extends StatelessWidget {
  ViolationsPage({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("violations".tr),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.violations.length,
            itemBuilder: (context, index) {
              final violation = controller.violations[index];

              return Card(
                color: Theme.of(context).cardColor,
                elevation: 3,
                shadowColor: AppColors.light,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Theme.of(context).cardColor,
                    backgroundColor: Theme.of(context).cardColor,
                    collapsedIconColor: Colors.red,
                    iconColor: Colors.red,
                    leading: const Icon(
                      Icons.report_problem,
                      color: Colors.red,
                    ),
                    title: Text(
                      violation["title"] ?? "",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      violation["description"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              Icons.description,
                              "description".tr,
                              violation["description"] ?? "",
                            ),

                            const SizedBox(height: 10),

                            _buildInfoRow(
                              context,
                              Icons.calendar_today,
                              "violation_date".tr,
                              violation["violation_date"] ?.toString().split("T").first ?? ""
                            ),

                            const SizedBox(height: 10),

                            _buildInfoRow(
                              context,
                              Icons.gavel,
                              "penalty".tr,
                              violation["penalty"] ?? "",
                            ),

                            const SizedBox(height: 10),

                            _buildInfoRow(
                              context,
                              Icons.category,
                              "category".tr,
                              violation["category"] ?? "",
                            ),
                          ],
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
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.secondary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}