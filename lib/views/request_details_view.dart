import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class RequestDetailsView extends StatelessWidget {
  const RequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestController controller = Get.find<RequestController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(38),
                    ),
                  ),
                  child: Obx(() {
                    final request = controller.selectedRequest.value;

                    if (controller.isLoadingRequestDetails.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (request == null) {
                      return const Center(
                        child: Text("لا توجد تفاصيل لهذا الطلب"),
                      );
                    }

                    final metadata = request['metadata'] is Map
                        ? request['metadata'] as Map
                        : {};

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statusBox(request['status']),
                          const SizedBox(height: 18),

                          _sectionTitle("معلومات الطلب"),
                          _detailCard(
                            icon: _typeIcon(request),
                            title: "نوع الطلب",
                            value: _typeText(request),
                          ),
                          _detailCard(
                            icon: Icons.title,
                            title: "العنوان",
                            value: request['title'],
                          ),
                          _detailCard(
                            icon: Icons.calendar_month,
                            title: "تاريخ الإنشاء",
                            value: _formatDate(request['created_at']),
                          ),

                          if (metadata.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _sectionTitle("تفاصيل الطلب"),
                            ..._sortedMetadata(metadata).map(
                              (e) => _detailCard(
                                icon: _metadataIcon(e.key),
                                title: _metadataLabel(e.key, request),
                                value: _metadataValue(
                                  key: e.key,
                                  value: e.value,
                                  controller: controller,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              "تفاصيل الطلب",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBox(dynamic status) {
    final color = _statusColor(status?.toString());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 10),
          const Text(
            "حالة الطلب:",
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _statusText(status),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkPurple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required dynamic value,
  }) {
    if (value == null || value.toString().trim().isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.softLavender.withOpacity(.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mauve.withOpacity(.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(icon, color: AppColors.darkPurple, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<MapEntry> _sortedMetadata(Map metadata) {
    final entries = metadata.entries.toList();

    const order = {
      'exit_date': 1,
      'from_hour': 2,
      'to_hour': 3,
      'current_room_id': 4,
      'requested_room_id': 5,
      'target_room_id': 6,
      'reason': 7,
      'admin_response': 8,
      'approval_reason': 8,
      'rejection_reason': 8,
      'admin_notes': 8,
      'notes': 8,
    };

    entries.sort((a, b) {
      final aOrder = order[a.key.toString()] ?? 999;
      final bOrder = order[b.key.toString()] ?? 999;
      return aOrder.compareTo(bOrder);
    });

    return entries;
  }

  dynamic _metadataValue({
    required dynamic key,
    required dynamic value,
    required RequestController controller,
  }) {
    final k = key.toString();

    if (k == 'current_room_id' ||
        k == 'requested_room_id' ||
        k == 'target_room_id') {
      return _roomNameById(value, controller);
    }

    return value;
  }

  String _roomNameById(dynamic roomId, RequestController controller) {
    for (final room in controller.rooms) {
      if (room['id'].toString() == roomId.toString()) {
        final number = room['room_number'] ?? room['number'] ?? '-';
        final unitRaw =
            room['dormitory_unit']?['name'] ?? room['dormitory_unit_name'];

        return "الغرفة $number - ${_unitArabicName(unitRaw?.toString())}";
      }
    }

    return "غرفة غير معروفة";
  }

  String _unitArabicName(String? name) {
    switch (name) {
      case "Building A":
        return "مبنى الطالبات الأول";
      case "Building B":
        return "مبنى الطالبات الثاني";
      case "Building C":
        return "مبنى الطالبات الثالث";
      default:
        return name ?? "غير محدد";
    }
  }

  IconData _typeIcon(Map<String, dynamic> request) {
    final type = request['request_type']?.toString();
    final changeType = request['room_change_type']?.toString();

    if (type == 'student_exit_permission') return Icons.exit_to_app;
    if (changeType == 'specific_room') return Icons.meeting_room;
    if (changeType == 'exchange') return Icons.swap_horiz;
    if (changeType == 'any_available') return Icons.move_up;

    return Icons.description;
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusText(dynamic status) {
    switch (status?.toString()) {
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'قيد الانتظار';
    }
  }

  String _typeText(Map<String, dynamic> request) {
    final type = request['request_type']?.toString();
    final changeType = request['room_change_type']?.toString();

    if (type == 'student_exit_permission') return 'سماح خروج من السكن';
    if (changeType == 'specific_room') return 'تبديل غرفة بدون بديلة';
    if (changeType == 'exchange') return 'تبديل غرفة مع طالبة';
    if (changeType == 'any_available') return 'نقل لأي غرفة متاحة';

    return type ?? 'طلب';
  }

  String _metadataLabel(dynamic key, Map<String, dynamic> request) {
    final type = request['request_type']?.toString();
    final changeType = request['room_change_type']?.toString();

    switch (key.toString()) {
      case 'exit_date':
        return 'تاريخ الخروج';
      case 'from_hour':
        return 'من الساعة';
      case 'to_hour':
        return 'إلى الساعة';
      case 'reason':
        if (type == 'student_exit_permission') return 'سبب الخروج';
        if (changeType == 'any_available') return 'سبب النقل';
        return 'سبب التبديل';
      case 'current_room_id':
        return 'الغرفة الحالية';
      case 'requested_room_id':
        return 'الغرفة المطلوبة';
      case 'target_room_id':
        return 'غرفة الطالبة البديلة';
      case 'admin_response':
      case 'approval_reason':
      case 'admin_notes':
      case 'notes':
        return 'ملاحظات الإدارة';
      case 'rejection_reason':
        return 'سبب الرفض';
      default:
        return key.toString();
    }
  }

  IconData _metadataIcon(dynamic key) {
    switch (key.toString()) {
      case 'exit_date':
        return Icons.event;
      case 'from_hour':
      case 'to_hour':
        return Icons.access_time;
      case 'reason':
        return Icons.notes;
      case 'current_room_id':
        return Icons.home;
      case 'requested_room_id':
      case 'target_room_id':
        return Icons.meeting_room;
      case 'admin_response':
      case 'approval_reason':
      case 'rejection_reason':
      case 'admin_notes':
      case 'notes':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final d = DateTime.parse(date.toString());
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return date.toString();
    }
  }
}