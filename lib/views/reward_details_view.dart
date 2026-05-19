import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_details_controller.dart';
import '../utlis/app_colors.dart';

class RewardDetailsView extends StatelessWidget {
  final int id;

  const RewardDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RewardDetailsController(id));

    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("Reward Details"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reward.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final r = controller.reward;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                    const SizedBox(height: 10),

                    Text(
                      r['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _item("Description", r['description']),
              _item("Date", r['created_at']),
            ],
          ),
        );
      }),
    );
  }

  Widget _item(String title, dynamic value) {
    if (value == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }
}