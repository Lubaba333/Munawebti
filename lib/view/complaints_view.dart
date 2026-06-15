import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/complaint_controller.dart';
import 'package:supervisors/services/api_service.dart';
import 'package:supervisors/view/complaint_detail_view.dart';


class ComplaintsView extends StatelessWidget {
  ComplaintsView({super.key});

  final controller = Get.put(
    ComplaintController(ApiService()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Housing Complaints"),
        backgroundColor: AppColors.primary,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.to(() => AddComplaintView());
        },
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaints.isEmpty) {
          return const Center(
            child: Text("No complaints found"),
          );
        }

         return  ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            final item = controller.complaints[index];

            return _AnimatedComplaintCard(
              index: index,
              child: GestureDetector(
                onTap: () async {
                  final detail =
                  await Get.find<ComplaintController>()
                      .getComplaintById(item.id);

                  Get.to(() => ComplaintDetailView(
                    complaint: detail,
                  ));
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Title + Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusBadge(status: item.status),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// Description
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      /// Footer
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 16, color: Colors.grey),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              item.creator.fullName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Text(
                            item.createdAt.substring(0, 10),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}



class AddComplaintView extends StatelessWidget {
  AddComplaintView({super.key});

  final controller = Get.find<ComplaintController>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final  complaintTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Complaint"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),

            TextField(
              controller: complaintTypeController,
              decoration: const InputDecoration(
                labelText: "complaint_type",
              ),
            ),

            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),


            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                controller.createComplaint(
                  studentId: 1, // لاحقاً من user session
                  title: titleController.text,
                  complaint_type:complaintTypeController.text,
                  description: descController.text,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}


class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color getColor() {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: getColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: getColor(),
        ),
      ),
    );
  }
}


class _AnimatedComplaintCard extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedComplaintCard({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedComplaintCard> createState() =>
      _AnimatedComplaintCardState();
}

class _AnimatedComplaintCardState
    extends State<_AnimatedComplaintCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    /// ⏱️ تأخير بسيط لكل عنصر (stagger effect)
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}