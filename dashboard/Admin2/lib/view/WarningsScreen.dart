import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/WarningsController.dart';
import '../model/user_model.dart';

class WarningsScreen extends StatelessWidget {
  final UserModel user;

  WarningsScreen({super.key, required this.user});

  late final WarningsController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(WarningsController(user: user));

    return SafeArea(
      child: Column(
        children: [

          /// ================= LIST =================
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.warnings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.warnings.isEmpty) {
                return const Center(child: Text("No Warnings Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.warnings.length,
                itemBuilder: (context, index) {
                  final w = controller.warnings[index];

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
                                w.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(w.description),
                              const SizedBox(height: 5),
                              Text("Date: ${w.warningDate}"),
                              Text("Penalty: ${w.possiblePenalty}"),
                              Text("Type: ${w.targetType}"),
                            ],
                          ),
                        ),

                        /// ACTIONS
                        Column(
                          children: [

                            /// EDIT
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                controller.titleController.text = w.title;
                                controller.descriptionController.text = w.description;
                                controller.dateController.text = w.warningDate;
                                controller.penaltyController.text = w.possiblePenalty;

                                Get.defaultDialog(
                                  title: "Update Warning",
                                  content: Column(
                                    children: [

                                      TextField(
                                        controller: controller.titleController,
                                      ),

                                      const SizedBox(height: 10),

                                      ElevatedButton(
                                        onPressed: () {
                                          controller.updateWarning(w.id);
                                          Get.back();
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            /// DELETE
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.deleteWarning(w.id);
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

          /// ================= ADD =================
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () => _showCreateDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Add Warning"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CREATE =================
  void _showCreateDialog() {
    Get.defaultDialog(
      title: "Create Warning",
      content: Column(
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
            controller: controller.dateController,
            decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
          ),

          TextField(
            controller: controller.penaltyController,
            decoration: const InputDecoration(hintText: "Penalty"),
          ),

          const SizedBox(height: 10),

          Obx(() => DropdownButton<String>(
            value: controller.targetType.value,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: "student", child: Text("Student")),
              DropdownMenuItem(value: "supervisor", child: Text("Supervisor")),
            ],
            onChanged: (value) {
              if (value != null) {
                controller.targetType.value = value;
              }
            },
          )),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              controller.createWarning();
              Get.back();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}