import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class RequestDetailsView extends StatelessWidget {
  const RequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final RequestController controller = Get.find<RequestController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(38),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(.22)
                            : AppColors.deepPurple.withOpacity(.08),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final request = controller.selectedRequest.value;

                    if (controller.isLoadingRequestDetails.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    if (request == null) {
                      return Center(
                        child: Text(
                          "no_request_details".tr,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final metadata =
                        request['metadata'] is Map ? request['metadata'] as Map : {};

                    final requester =
                        request['requester'] is Map ? request['requester'] as Map : null;

                    final targetStudent = request['target_student'] is Map
                        ? request['target_student'] as Map
                        : null;

                    final items = <_DetailItem>[
                      _DetailItem(
                        icon: _typeIcon(request),
                        title: "request_type".tr,
                        value: _typeText(request),
                      ),
                      if (requester != null)
                        _DetailItem(
                          icon: Icons.person_rounded,
                          title: "requester_student".tr,
                          value: requester['full_name'],
                        ),
                      if (requester?['current_room'] is Map)
                        _DetailItem(
                          icon: Icons.home_rounded,
                          title: "requester_room".tr,
                          value: _studentRoomText(requester?['current_room']),
                        ),
                      if (targetStudent != null)
                        _DetailItem(
                          icon: Icons.person_search_rounded,
                          title: "target_student".tr,
                          value: targetStudent['full_name'],
                        ),
                      if (targetStudent?['current_room'] is Map)
                        _DetailItem(
                          icon: Icons.meeting_room_rounded,
                          title: "target_student_room".tr,
                          value: _studentRoomText(targetStudent?['current_room']),
                        ),
                      _DetailItem(
                        icon: Icons.title_rounded,
                        title: "title_type".tr,
                        value: request['title'],
                      ),
                      _DetailItem(
                        icon: Icons.calendar_month_rounded,
                        title: "created_at".tr,
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
                      if (request['target_student_rejection_reason'] != null)
                        _DetailItem(
                          icon: Icons.cancel_rounded,
                          title: "target_student_rejection_reason".tr,
                          value: request['target_student_rejection_reason'],
                        ),
                      if (request['target_student_approved_at'] != null)
                        _DetailItem(
                          icon: Icons.check_circle_rounded,
                          title: 'target_student_approved_at'.tr,
                          value: _formatDate(request['target_student_approved_at']),
                        ),
                      if (request['admin_response_reason'] != null)
                        _DetailItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: "admin_response".tr,
                          value: request['admin_response_reason'],
                        ),
                    ].where((e) {
                      return e.value != null && e.value.toString().trim().isNotEmpty;
                    }).toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statusHeader(context, request['status']),
                          const SizedBox(height: 26),
                          Text(
                            "request_details".tr,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.titleLarge?.color,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;

                            return _detailLine(
                              context,
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "request_details".tr,
              style: const TextStyle(
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

  Widget _statusHeader(BuildContext context, dynamic status) {
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
              Text(
                "request_status".tr,
                style: const TextStyle(
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

  Widget _detailLine(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isLast,
  }) {
    final isDark = Get.isDarkMode;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
                size: 23,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? AppColors.mauve : AppColors.darkPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
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
            color: Theme.of(context).dividerColor.withOpacity(.35),
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

        return "${"room".tr} $number - ${_unitArabicName(unitRaw?.toString())}";
      }
    }

    return "unknown_room".tr;
  }

  String _studentRoomText(dynamic room) {
    if (room is! Map) return "not_specified".tr;

    final number = room['room_number'] ?? room['number'] ?? '-';
    final unitRaw = room['dormitory_unit']?['name'] ??
        room['dormitory_unit_name'];

    return "${"room".tr} $number - ${_unitArabicName(unitRaw?.toString())}";
  }

  String _unitArabicName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return "not_specified".tr;
    }

    switch (name.trim()) {
      case "Building A":
      case "Building 1":
      case "A":
      case "1":
        return "building_1".tr;

      case "Building B":
      case "Building 2":
      case "B":
      case "2":
        return "building_2".tr;

      case "Building C":
      case "Building 3":
      case "C":
      case "3":
        return "building_3".tr;

      default:
        return name;
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
        return 'approved'.tr;
      case 'rejected':
        return 'rejected'.tr;
      default:
        return 'pending'.tr;
    }
  }

  String _typeText(Map<String, dynamic> request) {
    final type = request['request_type']?.toString();
    final changeType = request['room_change_type']?.toString();

    if (type == 'student_exit_permission') return 'exit_permission'.tr;
    if (changeType == 'specific_room') {
      return 'room_change_without_alternative'.tr;
    }
    if (changeType == 'exchange') return 'room_exchange_with_student'.tr;
    if (changeType == 'any_available') {
      return 'transfer_to_any_available_room'.tr;
    }

    return type ?? 'request'.tr;
  }

  String _metadataLabel(dynamic key, Map<String, dynamic> request) {
    final type = request['request_type']?.toString();
    final changeType = request['room_change_type']?.toString();

    switch (key.toString()) {
      case 'exit_date':
        return 'exit_date'.tr;
      case 'from_hour':
        return 'from_hour'.tr;
      case 'to_hour':
        return 'to_hour'.tr;
      case 'reason':
        if (type == 'student_exit_permission') return 'exit_reason'.tr;
        if (changeType == 'any_available') return 'transfer_reason'.tr;
        return 'exchange_reason'.tr;
      case 'current_room_id':
        return 'current_room'.tr;
      case 'requested_room_id':
        return 'requested_room'.tr;
      case 'target_room_id':
        return 'target_student_room'.tr;
      case 'admin_response':
      case 'approval_reason':
      case 'admin_notes':
      case 'notes':
        return 'admin_notes'.tr;
      case 'rejection_reason':
        return 'rejection_reason'.tr;
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