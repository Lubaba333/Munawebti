import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ComplaintController.dart';

class ComplaintsView extends StatelessWidget {
  ComplaintsView({super.key});

  final ComplaintController controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    // 🔴 ممنوع داخل build بدون شرط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchComplaints();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaints.isEmpty) {
          return const Center(child: Text("No complaints"));
        }

        return ListView.builder(
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            final c = controller.complaints[index];

            return Card(
              child: ListTile(
                title: Text(c.title),
                subtitle: Text("Status: ${c.status}"),

                onTap: () {
                  _showComplaintCard(c.id);
                },
              ),
            );
          },
        );
      }),
    );
  }

  // ================= SMALL CARD =================
  void _showComplaintCard(int id) {
    final controller = Get.find<ComplaintController>();

    final TextEditingController responseController = TextEditingController();

    controller.fetchComplaintDetails(id);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(12),
        height: 450,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),

        child: Obx(() {
          final c = controller.selectedComplaint.value;

          if (c == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                c.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text("Description: ${c.description}"),
              const SizedBox(height: 10),

              Text("Response: ${c.adminResponse ?? ""}"),

              const Divider(),

              TextField(
                controller: responseController,
                decoration: const InputDecoration(
                  hintText: "Write response...",
                ),
              ),

              const SizedBox(height: 10),

              /// ================= STATUS DROPDOWN =================
              Obx(() {
                return DropdownButton<String>(
                  value: controller.selectedStatus.value,
                  items: const [
                    DropdownMenuItem(
                      value: "reviewed",
                      child: Text("reviewed"),
                    ),
                    DropdownMenuItem(
                      value: "resolved",
                      child: Text("resolved"),
                    ),
                    DropdownMenuItem(
                      value: "rejected",
                      child: Text("rejected"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedStatus.value = value;
                    }
                  },
                );
              }),

              const SizedBox(height: 10),

              Row(
                children: [

                  ElevatedButton(
                    onPressed: () {
                      controller.respondComplaint(
                        c.id,
                        responseController.text,
                      );
                    },
                    child: const Text("Send Response"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () {
                      controller.updateComplaint(
                        c.id,
                        controller.selectedStatus.value,
                      );
                    },
                    child: const Text("Update Status"),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}