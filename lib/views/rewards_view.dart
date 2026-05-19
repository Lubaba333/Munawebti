import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../utlis/app_colors.dart';
import 'reward_details_view.dart';

class RewardsView extends StatelessWidget {
  RewardsView({super.key});

  final controller = Get.put(RewardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("My Rewards"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rewards.isEmpty) {
          return const Center(
            child: Text("No rewards yet 🎁"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rewards.length,
          itemBuilder: (context, index) {
            final r = controller.rewards[index];
            return _buildCard(r);
          },
        );
      }),
    );
  }

  Widget _buildCard(r) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RewardDetailsView(id: r.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade400,
              Colors.amber.shade200,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 30),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r.date,
                    style: const TextStyle(color: Colors.white70),
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