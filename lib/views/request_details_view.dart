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
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
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

                    final items = <_DetailItem>[
                      _DetailItem(
                        icon: _typeIcon(request),
                        title: "نوع الطلب",
                        value: _typeText(request),
                      ),
                      _DetailItem(
                        icon: Icons.title_rounded,
                        title: "العنوان",
                        value: request['title'],
                      ),
                      
                      _DetailItem(
                        icon: Icons.calendar_month_rounded,
                        title: "تاريخ الإنشاء",
                        value: _formatDate(request['created_at']),
                      ),
                      ..._sortedMetadata(metadata).map(
                        (e) => _DetailItem(
                          icon: _metadataIcon(e.key),
                          title: _metadataLabel(e.key, request),
                          value: _metadataValue(
                            key: e.key,
                            value: e.value,
                            controller: controller,
                          ),
                        ),
                      ),
                      if (request['admin_response_reason'] != null)
                        _DetailItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: "رد الإدارة",
                          value: request['admin_response_reason'],
                        ),
                    ].where((e) {
                      return e.value != null &&
                          e.value.toString().trim().isNotEmpty;
                    }).toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statusHeader(request['status']),
                          const SizedBox(height: 26),
                          const Text(
                            "تفاصيل الطلب",
                            style: TextStyle(
                              color: AppColors.darkPurple,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return _detailLine(
                              icon: item.icon,
                              title: item.title,
                              value: item.value.toString(),
                              isLast: index == items.length - 1,
                            );
                          }),
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

  Widget _statusHeader(dynamic status) {
    final color = _statusColor(status?.toString());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.95),
            color.withOpacity(.62),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_turned_in_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "حالة الطلب",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _statusText(status),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailLine({
    required IconData icon,
    required String title,
    required String value,
    required bool isLast,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.darkPurple,
                size: 23,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.darkPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
      ],
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

    if (type == 'student_exit_permission') return Icons.exit_to_app_rounded;
    if (changeType == 'specific_room') return Icons.meeting_room_rounded;
    if (changeType == 'exchange') return Icons.swap_horiz_rounded;
    if (changeType == 'any_available') return Icons.move_up_rounded;

    return Icons.description_rounded;
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
        return Icons.event_rounded;
      case 'from_hour':
      case 'to_hour':
        return Icons.access_time_rounded;
      case 'reason':
        return Icons.notes_rounded;
      case 'current_room_id':
        return Icons.home_rounded;
      case 'requested_room_id':
      case 'target_room_id':
        return Icons.meeting_room_rounded;
      case 'admin_response':
      case 'approval_reason':
      case 'rejection_reason':
      case 'admin_notes':
      case 'notes':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.info_outline_rounded;
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

class _DetailItem {
  final IconData icon;
  final String title;
  final dynamic value;

  _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}