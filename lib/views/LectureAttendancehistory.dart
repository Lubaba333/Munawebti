import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studants/controllers/lecture_attendance_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class AttendanceHistoryView extends StatelessWidget {
  const AttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LectureAttendanceController>();
    final isDark = Get.isDarkMode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAttendanceHistory();
    });

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
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(.22) : AppColors.deepPurple.withOpacity(.08),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.mauve));
                    }

                    if (controller.attendanceHistory.isEmpty) {
                      return _emptyState(context);
                    }

                    return _buildTimeline(context, controller.attendanceHistory);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== الهيدر ====================
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
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(Icons.history, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "attendance_history".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "attendance_history_subtitle".tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== الحالة الفارغة ====================
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.white.withOpacity(.08) : AppColors.softLavender,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.history, size: 52, color: Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple),
          ),
          const SizedBox(height: 18),
          Text(
            "no_attendance_records".tr,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "start_attendance_message".tr,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ==================== ملخص إحصائي + الخط الزمني ====================
   Widget _buildTimeline(BuildContext context, List<Map<String, dynamic>> records) {
    final total = records.length;
    
    final presentCount = records.where((r) {
      final status = (r['status'] as String?)?.toLowerCase();
      return status == 'present';
    }).length;
    
    final absentCount = total - presentCount;
    final rate = total == 0 ? 0 : ((presentCount / total) * 100).round();

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final r in records) {
      final shift = r['shift'] as Map<String, dynamic>?;
      final dateStr = shift?['shift_date'];
      DateTime? date;
      try {
        date = dateStr != null ? DateTime.parse(dateStr) : null;
      } catch (_) {
        date = null;
      }
      final key = date != null ? "${date.year}-${date.month.toString().padLeft(2, '0')}" : "unknown".tr;
      grouped.putIfAbsent(key, () => []).add(r);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _summaryBar(context, total: total, present: presentCount, absent: absentCount, rate: rate),
        ),
        for (final monthKey in sortedKeys) ...[
          SliverToBoxAdapter(child: _monthHeader(context, monthKey)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final items = grouped[monthKey]!;
                  final isLast = index == items.length - 1;
                  return _timelineItem(context, items[index], isLast: isLast);
                },
                childCount: grouped[monthKey]!.length,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  // ==================== شريط الإحصائيات ====================
  Widget _summaryBar(BuildContext context, {required int total, required int present, required int absent, required int rate}) {
    final isDark = Get.isDarkMode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(.04) : AppColors.softLavender.withOpacity(.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            _statColumn(context, value: "$rate%", label: "attendance  rate".tr, color: AppColors.darkPurple),
            _statDivider(),
            _statColumn(context, value: "$present", label: "present".tr, color: Colors.green),
            _statDivider(),
            _statColumn(context, value: "$absent", label: "absent".tr, color: Colors.red),
            _statDivider(),
            _statColumn(context, value: "$total", label: "total".tr, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(BuildContext context, {required String value, required String label, required Color color}) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 34, color: Colors.grey.withOpacity(.25));
  }

  // ==================== عنوان الشهر ====================
  Widget _monthHeader(BuildContext context, String monthKey) {
    String label = "unknown".tr;
    if (monthKey != "unknown".tr) {
      final parts = monthKey.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      label = "${_arabicMonth(month)} $year";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(.65),
        ),
      ),
    );
  }

  // ==================== عنصر الخط الزمني ====================
  Widget _timelineItem(BuildContext context, Map<String, dynamic> record, {required bool isLast}) {
    final isDark = Get.isDarkMode;
    final shift = record['shift'] as Map<String, dynamic>?;
    final shiftDetails = record['shift_details'] as Map<String, dynamic>?;
    
    final status = (record['status'] as String?)?.toLowerCase() ?? '';
    final isPresent = status == 'present';
    final statusColor = isPresent ? Colors.green : Colors.red;
    final statusText = isPresent ? 'present'.tr : 'absent'.tr;

    final subjectName = shiftDetails?['subject_name'] ?? 'lecture'.tr;
    final dayNumber = _dayNumberFromDate(shift?['shift_date']);
    final weekday = _arabicDay(shift?['day'] ?? '');
    final time = _formatTimeRange(shift?['from_hour'], shift?['to_hour']);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  border: Border.all(color: statusColor.withOpacity(.25), width: 4),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: (isDark ? Colors.white : Colors.grey).withOpacity(.15),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 4 : 22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dayNumber,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subjectName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).textTheme.titleLarge?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: statusColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(weekday, style: TextStyle(fontSize: 11.5, color: Colors.grey[600])),
                            const SizedBox(width: 10),
                            Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(time, style: TextStyle(fontSize: 11.5, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== دوال مساعدة ====================
  String _dayNumberFromDate(String? date) {
    if (date == null) return '--';
    try {
      return DateTime.parse(date).day.toString();
    } catch (_) {
      return '--';
    }
  }

  String _formatTimeRange(String? from, String? to) {
    if (from == null || to == null) return '--:--';
    try {
      final f = DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(from));
      final t = DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(to));
      return '$f - $t';
    } catch (_) {
      return '$from - $to';
    }
  }

  String _arabicDay(String day) {
    switch (day.trim()) {
      case 'Sunday': return 'sunday'.tr;
      case 'Monday': return 'monday'.tr;
      case 'Tuesday': return 'tuesday'.tr;
      case 'Wednesday': return 'wednesday'.tr;
      case 'Thursday': return 'thursday'.tr;
      case 'Friday': return 'friday'.tr;
      case 'Saturday': return 'saturday'.tr;
      default: return day;
    }
  }

  String _arabicMonth(int month) {
    const months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december',
    ];
    return months[month - 1].tr;
  }
}