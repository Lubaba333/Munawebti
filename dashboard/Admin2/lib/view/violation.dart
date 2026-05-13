import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/violation_controller.dart';
import '../model/user_model.dart';

class ViolationsScreen extends StatelessWidget {
  final UserModel user;

  ViolationsScreen({super.key, required this.user});

  late final ViolationsController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(ViolationsController(user: user));

    return SafeArea(
      child: Column(
        children: [

          /// ================= LIST =================
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.violations.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.violations.isEmpty) {
                return const Center(child: Text("No Violations Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.violations.length,
                itemBuilder: (context, index) {
                  final v = controller.violations[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Row(
                      children: [

                        /// ================= INFO =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                v.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(v.description),
                              const SizedBox(height: 6),

                              Text("Penalty: ${v.penalty}"),
                              Text("Date: ${v.violationDate}"),
                              Text("Category: ${v.category}"),
                              Text("Target: ${v.targetType}"),
                            ],
                          ),
                        ),

                        /// ================= ACTIONS =================
                        Row(
                          children: [

                            /// ✏️ EDIT BUTTON
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                _showUpdateDialog(v);
                              },
                            ),

                            /// 🗑 DELETE
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.deleteViolation(v.id);
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
                onPressed: () => _showCreateDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Add Violation"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CREATE =================
  void _showCreateDialog() {
    _showFormDialog(isUpdate: false);
  }

  // ================= UPDATE =================
  void _showUpdateDialog(v) {
    controller.titleController.text = v.title;
    controller.descriptionController.text = v.description;
    controller.penaltyController.text = v.penalty.toString();
    controller.dateController.text = v.violationDate;
    controller.categoryController.text = v.category;
    controller.targetType.value = v.targetType;

    _showFormDialog(isUpdate: true, id: v.id);
  }

  // ================= FORM DIALOG =================
  void _showFormDialog({required bool isUpdate, int? id}) {
    Get.defaultDialog(
      title: isUpdate ? "Update Violation" : "Create Violation",
      content: SizedBox(
        width: Get.width * 0.85,
        child: SingleChildScrollView(
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
                controller: controller.penaltyController,
                decoration: const InputDecoration(hintText: "Penalty"),
              ),

              TextField(
                controller: controller.dateController,
                decoration: const InputDecoration(hintText: "YYYY-MM-DD"),
              ),

              TextField(
                controller: controller.categoryController,
                decoration: const InputDecoration(hintText: "Category"),
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
                  controller.targetType.value = value!;
                },
              )),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  if (isUpdate) {
                    controller.updateViolation(id!);
                  } else {
                    controller.createViolation();
                  }
                  Get.back();
                },
                child: Text(isUpdate ? "Update" : "Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}