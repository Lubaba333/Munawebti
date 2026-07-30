import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/view/qr_scanner_view.dart';

import '../const/app_colors.dart';
import '../controller/attendance_controller.dart';
import '../models/shift_check_ins_model.dart';
import '../models/upcoming_shift_model.dart';
import '../services/api_service.dart';
import 'attendance_history_view.dart';


/// بالوت الألوان تبعك ما فيه ألوان دلالية لحالات الحضور (تم/بالانتظار/خطأ).
/// حطيتها هون بشكل منفصل وبسيط بدون ما أمس بألوان الهوية تبعك.
class _StatusColors {
  _StatusColors._();

  static const Color success = Color(0xFF5FAE86);
  static const Color pending = Color(0xFFE0A458);
  static const Color error = Color(0xFFD3616B);
}

class UpcomingShiftView extends GetView<AttendanceController> {
  // final controller = Get.put(AttendanceController());
   UpcomingShiftView({super.key});

  //final controller = Get.put(AttendanceController(ApiService()));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingShift.value &&
                    controller.upcomingShift.value == null) {
                  return const _LoadingState();
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.upcomingShift.value == null) {
                  return _ErrorState(
                    message: controller.errorMessage.value,
                    onRetry: controller.refresh,
                  );
                }

                if (controller.upcomingShift.value == null) {
                  return _EmptyState(onRefresh: controller.refresh);
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      _ShiftCard(shift: controller.upcomingShift.value!.shift),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        summary:
                            controller.upcomingShift.value!.checkInSummary,
                      ),
                      const SizedBox(height: 24),
                      _SectionLabel(count: controller.students.length),
                      const SizedBox(height: 12),
                      if (controller.isLoadingCheckIns.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      else if (controller.students.isEmpty)
                        const _NoStudentsCheckedIn()
                      else
                        ...controller.students.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _StudentTile(checkIn: s),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الشيفت القادم',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'تسجيل حضور الطلاب',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: Icons.history_rounded,
            onTap: () async {
              await Get.to(() => AttendanceHistoryView());
            },
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: Icons.qr_code_scanner_rounded,
            onTap: () async {
              await Get.to(() => const QrScannerView());
            },
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shift card
// ---------------------------------------------------------------------------

class _ShiftCard extends StatelessWidget {
  final ShiftModel shift;

  const _ShiftCard({required this.shift});

  @override
  Widget build(BuildContext context) {
    final isLecture = shift.shiftType == 'lecture';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.light.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isLecture
                      ? Icons.menu_book_rounded
                      : Icons.home_work_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLecture ? 'محاضرة' : 'سكن',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      _formatDate(shift.shiftDate),
                      style: const TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (shift.status != null) _StatusBadge(status: shift.status!),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '${_formatTime(shift.fromHour)} - ${_formatTime(shift.toHour)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  String get _label {
    switch (status) {
      case 'assigned':
        return 'مسند';
      case 'completed':
        return 'منتهي';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary row
// ---------------------------------------------------------------------------

class _SummaryRow extends StatelessWidget {
  final CheckInSummaryModel summary;

  const _SummaryRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatPill(
            label: 'تسجيل حضور',
            value: summary.attendanceRecorded,
            color: _StatusColors.success,
            icon: Icons.check_circle_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatPill(
            label: 'بالانتظار',
            value: summary.pendingScan,
            color: _StatusColors.pending,
            icon: Icons.hourglass_bottom_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatPill(
            label: 'إجمالي الحضور',
            value: summary.totalCheckedIn,
            color: AppColors.primary,
            icon: Icons.groups_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Students list
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final int count;

  const _SectionLabel({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'الطلاب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentTile extends StatelessWidget {
  final StudentCheckInModel checkIn;

  const _StudentTile({required this.checkIn});

  @override
  Widget build(BuildContext context) {
    final recorded = checkIn.attendanceRecorded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.light.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.light.withOpacity(0.5),
            child: Text(
              _initials(checkIn.student.fullName),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkIn.student.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${checkIn.student.studentIdentifier} · ${_formatTime(_timeFromDateTime(checkIn.checkInAt))}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (recorded ? _StatusColors.success : _StatusColors.pending)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  recorded
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  size: 14,
                  color: recorded ? _StatusColors.success : _StatusColors.pending,
                ),
                const SizedBox(width: 4),
                Text(
                  recorded ? 'مسجل' : 'قيد الانتظار',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: recorded ? _StatusColors.success : _StatusColors.pending,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '؟';
    if (parts.length == 1) return parts.first.substring(0, 1);
    return parts.first.substring(0, 1) + parts.last.substring(0, 1);
  }
}

// ---------------------------------------------------------------------------
// States: loading / empty / error / no students
// ---------------------------------------------------------------------------

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.light.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ما في شيفت قادم حالياً',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'رح يظهر هون أول ما يصير في طلاب مسجلين check-in',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded,
                  color: AppColors.primary),
              label: const Text(
                'تحديث',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoStudentsCheckedIn extends StatelessWidget {
  const _NoStudentsCheckedIn();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      alignment: Alignment.center,
      child: const Text(
        'لسا ما في طلاب عملوا check-in لهاد الشيفت',
        style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 40, color: _StatusColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Formatting helpers (بدون الاعتماد على مكتبة intl)
// ---------------------------------------------------------------------------

String _formatTime(String hhmmss) {
  final parts = hhmmss.split(':');
  if (parts.length < 2) return hhmmss;
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = parts[1];
  final period = hour >= 12 ? 'م' : 'ص';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$hour12:$minute $period';
}

String _timeFromDateTime(String dateTime) {
  // "2026-07-29 09:16:50" -> "09:16:50"
  final parts = dateTime.split(' ');
  return parts.length > 1 ? parts[1] : dateTime;
}

String _formatDate(String yyyyMmDd) {
  final parts = yyyyMmDd.split('-');
  if (parts.length != 3) return yyyyMmDd;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}
