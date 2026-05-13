import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/RewardsController.dart';
import '../model/RewardModel.dart';
import '../model/user_model.dart';


class RewardsScreen extends StatelessWidget {
  final UserModel user;

  RewardsScreen({super.key, required this.user});

  late final RewardsController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(RewardsController(user: user));

    return SafeArea(
      child: Column(
        children: [

          /// ================= LIST =================
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.rewards.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.rewards.isEmpty) {
                return const Center(child: Text("No Rewards Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.rewards.length,
                itemBuilder: (context, index) {
                  final reward = controller.rewards[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Row(
                      children: [

                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reward.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(reward.description),
                              const SizedBox(height: 5),
                              Text("Points: ${reward.points}"),
                              Text("Date: ${reward.rewardDate}"),
                              Text("Type: ${reward.rewardType}"),
                            ],
                          ),
                        ),

                        /// ACTIONS
                        Column(
                          children: [

                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showUpdateDialog(reward);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteReward(reward.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          /// ================= ADD BUTTON =================
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add Reward"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CREATE =================
  void _showCreateDialog() {
    _clearFields();
    _showFormDialog(isUpdate: false);
  }

  // ================= UPDATE =================
  void _showUpdateDialog(RewardModel reward) {
    controller.titleController.text = reward.title;
    controller.descriptionController.text = reward.description;
    controller.pointsController.text = reward.points.toString();
    controller.rewardDateController.text = reward.rewardDate;

    /// ❌ FIX IMPORTANT: targetType مو rewardType
    controller.targetType.value = reward.targetType;

    _showFormDialog(isUpdate: true, id: reward.id);
  }

  // ================= FORM =================
  void _showFormDialog({required bool isUpdate, int? id}) {
    Get.defaultDialog(
      title: isUpdate ? "Update Reward" : "Create Reward",
      content: SingleChildScrollView(
        child: Column(
          children: [

            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),

            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),

            TextField(
              controller: controller.pointsController,
              decoration: const InputDecoration(hintText: "Points"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: controller.rewardDateController,
              decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
            ),

            const SizedBox(height: 10),

            /// DROPDOWN FIXED
            Obx(() {
              final value = controller.targetType.value.isEmpty
                  ? "student"
                  : controller.targetType.value;

              return DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: "student", child: Text("Student")),
                  DropdownMenuItem(
                      value: "supervisor", child: Text("Supervisor")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.targetType.value = value;
                  }
                },
              );
            }),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                if (isUpdate) {
                  controller.updateReward(id!);
                } else {
                  controller.createReward();
                }
                Get.back();
              },
              child: Text(isUpdate ? "Update" : "Create"),
            ),
          ],
        ),
      ),
    );
  }

  void _clearFields() {
    controller.titleController.clear();
    controller.descriptionController.clear();
    controller.pointsController.clear();
    controller.rewardDateController.clear();
    controller.targetType.value = "student";
  }
}