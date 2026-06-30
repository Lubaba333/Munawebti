import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ProfileController.dart';

class RewardsPage extends StatelessWidget {
  final ProfileController controller = Get.find();

  RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Rewards"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildRewardsList(),
      ),
    );
  }

  Widget _buildRewardsList() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.rewards.length,
        itemBuilder: (context, index) {
          final reward = controller.rewards[index];

          return Card(
            color: Colors.white,
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
                collapsedBackgroundColor: Colors.white,
                backgroundColor: AppColors.background,
                collapsedIconColor: AppColors.primary,
                iconColor: AppColors.primary,
                leading: const Icon(
                  Icons.card_giftcard,
                  color: AppColors.primary,
                ),
                title: Text(
                  reward["title"] ?? "",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  reward["description"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.description,
                          "Description",
                          reward["description"] ?? "",
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
    });
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
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
              style: const TextStyle(
                color: Colors.black87,
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
