import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ProfileController.dart';

class WarningsPage extends StatelessWidget {
  WarningsPage({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warnings"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.warnings.length,
            itemBuilder: (context, index) {
              final warning = controller.warnings[index];

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
                    collapsedIconColor: Colors.orange,
                    iconColor: Colors.orange,
                    leading: const Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                    ),
                    title: Text(
                      warning["title"] ?? "",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      warning["description"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [

                            _buildInfoRow(
                              context,
                              Icons.description,
                              "Description",
                              warning["description"] ?? "",
                            ),

                            const SizedBox(height: 10),

                            _buildInfoRow(
                              context,
                              Icons.calendar_today,
                              "Warning Date",
                                warning["warning_date"]?.toString().split("T").first ?? ""
                            ),

                            const SizedBox(height: 10),

                            _buildInfoRow(
                              context,
                              Icons.gavel,
                              "Possible Penalty",
                              warning["possible_penalty"] ?? "",
                            ),
                          ],
                        ),
                      )
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
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