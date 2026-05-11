import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/housing_controller.dart';
import 'package:studants/widgets/gradient_button.dart';

class SwapView extends StatelessWidget {
  const SwapView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HousingController());
    final reasonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Swap Room")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔍 Autocomplete
            Autocomplete<Map<String, dynamic>>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) {
                  return const Iterable<Map<String, dynamic>>.empty();
                }

                return controller.students.where((student) {
                  final name = (student["name"] ?? "").toString();
                  return name
                      .toLowerCase()
                      .contains(value.text.toLowerCase());
                }).toList();
              },

              displayStringForOption: (option) =>
                  option["name"]?.toString() ?? "",

              onSelected: (student) {
                controller.selectedStudentId.value = student["id"];
              },

              fieldViewBuilder: (context, textController, focusNode, _) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: "Enter student name",
                    border: OutlineInputBorder(),
                  ),
                );
              },

              optionsViewBuilder: (context, onSelected, options) {
                return Material(
                  elevation: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      final student = options.elementAt(index);

                      return ListTile(
                        title: Text(student["name"] ?? ""),
                        subtitle:
                            Text("Room ${student["room"] ?? ""}"),
                        onTap: () => onSelected(student),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ✍️ Reason
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔘 Submit
            Obx(() => GradientButton(
                  text: "Submit",
                  isLoading: controller.isLoading.value,
                  onTap: () {
                    if (reasonController.text.isEmpty) {
                      Get.snackbar("Error", "Reason is required");
                      return;
                    }

                    controller.sendSwapRequest(reasonController.text);
                  },
                )),
          ],
        ),
      ),
    );
  }
}