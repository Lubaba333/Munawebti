import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/RequestController.dart';
import '../model/RequestModel.dart';
import '../widgets/AppColors.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(RequestController());

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
  );

  late AnimationController filterAnim;

  @override
  void initState() {
    super.initState();

    filterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void triggerFilterAnim() {
    filterAnim.forward(from: 0);
  }

  @override
  void dispose() {
    filterAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: headerGradient),
        ),
        title: const Text("Request Management"),
      ),

      body: Column(
        children: [

          /// 🔥 FILTER
          Obx(() => Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        "all",
                        "pending",
                        "approved",
                        "rejected",
                        "escalated"
                      ].map((filter) {

                        final isSelected =
                            controller.selectedFilter.value == filter;

                        return GestureDetector(
                          onTap: () {
                            controller.selectedFilter.value = filter;
                            triggerFilterAnim();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Chip(
                              label: Text(filter),
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                DropdownButton<String>(
                  value: controller.sortType.value,
                  items: const [
                    DropdownMenuItem(value: "newest", child: Text("Newest")),
                    DropdownMenuItem(value: "oldest", child: Text("Oldest")),
                  ],
                  onChanged: (v) => controller.sortType.value = v!,
                )
              ],
            ),
          )),

          /// 🔥 LIST
          Expanded(
            child: Obx(() {

              final list = controller.filteredRequests;

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (list.isEmpty) {
                return const Center(child: Text("No requests"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {

                  final RequestModel req = list[index];

                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        left: BorderSide(
                          color: _statusColor(req.status),
                          width: 4,
                        ),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(req.type,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),

                        const SizedBox(height: 5),

                        Text(req.status),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Colors.green),
                              onPressed: () {
                                controller.approveRequest(req.id);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Reject",
                                  content: TextField(
                                    onSubmitted: (v) {
                                      controller.rejectRequest(req.id, v);
                                      Get.back();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "escalated":
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}