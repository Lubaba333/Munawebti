import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class IncomingRequestsTab extends StatelessWidget {
  final RequestController controller;
  const IncomingRequestsTab({super.key, required this.controller});

  String _text(dynamic value) => value?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.requests.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final myId = controller.currentStudentId.value;

      final incoming = controller.requests.where((request) {
        final targetId = int.tryParse(_text(request['target_student_id']));
        return myId != null && targetId == myId;
      }).toList();

      if (incoming.isEmpty) {
        return const Center(child: Text("لا توجد طلبات واردة"));
      }

      return RefreshIndicator(
        onRefresh: controller.getMyRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: incoming.length,
          itemBuilder: (_, index) => _incomingCard(incoming[index]),
        ),
      );
    });
  }

  Widget _incomingCard(dynamic request) {
    final id = int.tryParse(_text(request['id']));
    final status = _text(request['status']).isEmpty ? 'pending' : _text(request['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.10),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
        border: Border.all(color: AppColors.mauve.withOpacity(.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.softLavender,
                child: Icon(Icons.swap_horiz, color: AppColors.darkPurple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _text(request['title']).isEmpty
                      ? "طلب تبديل غرفة وارد"
                      : _text(request['title']),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
                ),
              ),
              _statusChip(request),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _text(request['description']),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 14),
          if (status == 'pending' &&
    request['target_student_approved_at'] == null &&
    request['target_student_rejection_reason'] == null &&
    id != null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.approveExchangeRequest(id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("قبول", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRejectDialog(id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("رفض", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showRejectDialog(int requestId) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("رفض طلب التبديل"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: "سبب الرفض",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.rejectExchangeRequest(
                requestId: requestId,
                reason: reasonController.text,
              );
            },
            child: const Text("رفض", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

Widget _statusChip(dynamic request) {
  Color color = Colors.orange;
  String text = "بانتظار ردك";

  if (request['target_student_approved_at'] != null &&
      request['status'] == 'pending') {
    color = Colors.blue;
    text = "أنتِ وافقتِ وتم تحويل الطلب للإدارة";
  } else if (request['target_student_rejection_reason'] != null) {
    color = Colors.red;
    text = "أنتِ رفضتِ الطلب وتم إلغاؤه";
  } else if (request['status'] == 'approved') {
    color = Colors.green;
    text = "وافقت الإدارة";
  } else if (request['status'] == 'rejected') {
    color = Colors.red;
    text = "رفضت الإدارة";
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}