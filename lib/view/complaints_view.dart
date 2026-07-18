import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/complaint_controller.dart';
import 'package:supervisors/services/api_service.dart';
import 'package:supervisors/view/complaint_detail_view.dart';

class ComplaintsView extends StatelessWidget {
  ComplaintsView({super.key});

  final controller = Get.put(ComplaintController(ApiService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("complaints".tr),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label:  Text("New".tr),
        onPressed: () => Get.to(() => AddComplaintView()),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaints.isEmpty) {
          return const Center(child: Text("No complaints found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: controller.complaints.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = controller.complaints[index];

            return _AnimatedItem(
              index: index,
              child: _ComplaintTile(
                item: item,
                onTap: () async {
                  final detail =
                  await controller.getComplaintById(item.id);

                  Get.to(() => ComplaintDetailView(
                    complaint: detail,
                  ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}

// ================= TILE UI =================

class _ComplaintTile extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const _ComplaintTile({
    required this.item,
    required this.onTap,
  });

  Color _statusColor(String status) {
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
    final color = _statusColor(item.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),

      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TITLE
            Row(
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),


              ],
            ),

            const SizedBox(height: 8),

            // DESCRIPTION
            Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 10),

            // FOOTER + STATUS
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.createdAt.substring(0, 10),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ANIMATION =================

class _AnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedItem({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<_AnimatedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    fade = CurvedAnimation(parent: c, curve: Curves.easeOut);

    slide = Tween<Offset>(
      begin: const Offset(0, .1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) c.forward();
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: widget.child,
      ),
    );
  }
}

// ================= ADD VIEW =================

class AddComplaintView extends StatelessWidget {
  AddComplaintView({super.key});

  final controller = Get.find<ComplaintController>();

  final title = TextEditingController();
  final desc = TextEditingController();
  final type = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title:  Text("new_complaint".tr),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _field("title".tr, title),

            _field("type".tr, type),

            _field("description".tr, desc, max: 4),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.createComplaint(
                    studentId: 1,
                    title: title.text,
                    complaint_type: type.text,
                    description: desc.text,
                  );
                },
                child:  Text("submit".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c,
      {int max = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: max,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}