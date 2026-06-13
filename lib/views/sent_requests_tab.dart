import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class SentRequestsTab extends StatelessWidget {
  final RequestController controller;

  const SentRequestsTab({
    super.key,
    required this.controller,
  });

  String _text(dynamic value) => value?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.requests.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final myId = controller.currentStudentId.value;

      final sent = controller.requests.where((request) {
        final requesterId = int.tryParse(_text(request['requester_id']));
        final targetId = int.tryParse(_text(request['target_student_id']));

        if (myId == null) return true;

        return requesterId == myId || targetId == null;
      }).toList();

      if (sent.isEmpty) {
        return const Center(
          child: Text(
            "لا توجد طلبات حالياً",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.getMyRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: sent.length,
          itemBuilder: (_, index) {
            return _requestCard(sent[index]);
          },
        ),
      );
    });
  }

  Widget _requestCard(dynamic request) {
    final status =
        _text(request['status']).isEmpty ? 'pending' : _text(request['status']);

    final id = request['id'];
    final title = _text(request['title']).isEmpty
        ? _requestTypeName(request)
        : _text(request['title']);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
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
        border: Border.all(color: _statusColor(status).withOpacity(.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.softLavender,
                child: Icon(
                  _requestIcon(request),
                  color: AppColors.darkPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                  ),
                ),
              ),
              _statusChip(status),
            ],
          ),
          const SizedBox(height: 10),
       if (_requestReason(request).isNotEmpty)
  Text(
    "السبب: ${_requestReason(request)}",
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
  ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _formatDate(request['created_at']),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (id != null) {
                    controller.showRequestDetails(
                      int.parse(id.toString()),
                    );
                  }
                },
                child: const Text("التفاصيل"),
              ),
              if (status == 'pending' && id != null)
                TextButton(
                  onPressed: () {
                    controller.cancelRequest(
                      int.parse(id.toString()),
                    );
                  },
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

String _requestReason(dynamic request) {
  final metadata = request['metadata'];

  if (metadata is Map && metadata['reason'] != null) {
    return metadata['reason'].toString();
  }

  return "غير محدد";
}

  String _requestTypeName(dynamic request) {
    final type = _text(request['request_type']);
    final changeType = _text(request['room_change_type']);

    if (type == 'student_exit_permission') return "سماح خروج";
    if (changeType == 'exchange') return "تبديل غرفة مع طالبة";
    if (changeType == 'specific_room') return "تبديل لغرفة محددة";
    if (changeType == 'any_available') return "نقل لأي غرفة متاحة";

    return "طلب";
  }

  IconData _requestIcon(dynamic request) {
    final changeType = _text(request['room_change_type']);
    final type = _text(request['request_type']);

    if (type == 'student_exit_permission') return Icons.exit_to_app;
    if (changeType == 'exchange') return Icons.swap_horiz;
    if (changeType == 'specific_room') return Icons.meeting_room;
    if (changeType == 'any_available') return Icons.move_up;

    return Icons.description;
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'approved') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
  }

  String _statusText(String status) {
    if (status == 'approved') return 'مقبول';
    if (status == 'rejected') return 'مرفوض';
    return 'قيد الانتظار';
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final d = DateTime.parse(date);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return date;
    }
  }
}