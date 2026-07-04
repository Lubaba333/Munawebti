import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class IncomingRequestsTab extends StatelessWidget {
  final RequestController controller;

  const IncomingRequestsTab({
    super.key,
    required this.controller,
  });

  String _text(dynamic value) => value?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.receivedRequests.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.mauve),
        );
      }

      final incoming = controller.receivedRequests;

      if (incoming.isEmpty) {
        return Center(
          child: Text(
            "no_incoming_requests".tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.mauve,
        onRefresh: controller.getReceivedRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: incoming.length,
          itemBuilder: (_, index) => _incomingCard(context, incoming[index]),
        ),
      );
    });
  }

  Widget _incomingCard(BuildContext context, dynamic request) {
    final isDark = Get.isDarkMode;
    final id = int.tryParse(_text(request['id']));
    final status =
        _text(request['status']).isEmpty ? 'pending' : _text(request['status']);

    final canRespond = status == 'pending' &&
        request['target_student_approved_at'] == null &&
        request['target_student_rejection_reason'] == null &&
        id != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.20)
                : AppColors.deepPurple.withOpacity(.10),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
        border: Border.all(
          color: isDark
              ? AppColors.mauve.withOpacity(.18)
              : AppColors.mauve.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isDark
                    ? Colors.white.withOpacity(.08)
                    : AppColors.softLavender,
                child: Icon(
                  Icons.swap_horiz,
                  color: isDark ? AppColors.mauve : AppColors.darkPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _text(request['title']).isEmpty
                      ? "incoming_exchange_request".tr
                      : _text(request['title']),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
              ),
              _statusChip(request),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _text(request['description']),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                ),
              ),
              if (id != null) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => controller.showRequestDetails(id),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text("details".tr),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDark ? AppColors.mauve : AppColors.darkPurple,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (canRespond) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.approveExchangeRequest(id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text("accept".tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRejectDialog(requestId: id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text("reject".tr),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showRejectDialog({required int requestId}) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.cardColor,
        title: Text(
          "reject_exchange_request".tr,
          style: TextStyle(
            color: Get.textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: reasonController,
          style: TextStyle(color: Get.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: "rejection_reason".tr,
            hintStyle: TextStyle(color: Get.textTheme.bodyMedium?.color),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.rejectExchangeRequest(
                requestId: requestId,
                reason: reasonController.text,
              );
            },
            child: Text(
              "reject".tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(dynamic request) {
    Color color = Colors.orange;
    String text = "waiting_for_your_response".tr;

    if (request['target_student_approved_at'] != null &&
        request['status'] == 'pending') {
      color = Colors.blue;
      text = "you_approved_request_waiting_admin".tr;
    } else if (request['target_student_rejection_reason'] != null) {
      color = Colors.red;
      text = "you_rejected_request_cancelled".tr;
    } else if (request['status'] == 'approved') {
      color = Colors.green;
      text = "admin_approved".tr;
    } else if (request['status'] == 'rejected') {
      color = Colors.red;
      text = "admin_rejected".tr;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 125),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode ? color.withOpacity(.20) : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}