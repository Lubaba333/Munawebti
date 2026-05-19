import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/violation_details_controller.dart';
import '../utlis/app_colors.dart';

class ViolationDetailsView extends StatelessWidget {
  final int id;

  const ViolationDetailsView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViolationDetailsController(id));

    return Scaffold(
      backgroundColor: AppColors.softLavender,

      appBar: AppBar(
        title: const Text("Violation Details"),
        centerTitle: true,
        backgroundColor: AppColors.darkPurple,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.violation.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final v = controller.violation;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.gpp_bad, color: Colors.white, size: 40),
                    const SizedBox(height: 10),

                    Text(
                      v['title'] ?? '',
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

              _item("Description", v['description']),
              _item("Date", v['created_at']),
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