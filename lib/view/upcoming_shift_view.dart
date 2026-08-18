import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/view/qr_scanner_view.dart';

import '../const/app_colors.dart';

import '../controller/attendance_controller.dart';
import '../models/shift_check_ins_model.dart';
import '../models/upcoming_shift_model.dart';
import '../services/api_service.dart';
import 'attendance_history_view.dart';

class _StatusColors {
  _StatusColors._();

  static const Color success = Color(0xFF5FAE86);
  static const Color pending = Color(0xFFE0A458);
  static const Color error = Color(0xFFD3616B);
}

class UpcomingShiftView extends StatelessWidget {
  UpcomingShiftView({
    super.key,
    required this.shiftType,
  });

  /// lecture أو housing
  final String shiftType;

  late final AttendanceController controller = Get.put(
    AttendanceController(
      ApiService(),
      shiftType,
    ),
    tag: shiftType,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              shiftType: shiftType,
            ),
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
                  return _EmptyState(
                    onRefresh: controller.refresh,
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.refresh,
                  child: ListView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                        20, 8, 20, 24),
                    children: [

                      _ShiftCard(
                        shift:
                        controller.upcomingShift.value!.shift,
                      ),

                      const SizedBox(height: 16),

                      _SummaryRow(
                        summary: controller
                            .upcomingShift
                            .value!
                            .checkInSummary,
                      ),

                      const SizedBox(height: 24),

                      _SectionLabel(
                        count: controller.students.length,
                      ),

                      const SizedBox(height: 12),

                      if (controller
                          .isLoadingCheckIns.value)
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          child: Center(
                            child:
                            CircularProgressIndicator(
                              color:
                              AppColors.primary,
                            ),
                          ),
                        )
                      else if (controller
                          .students.isEmpty)
                        const _NoStudentsCheckedIn()
                      else
                        ...controller.students.map(
                              (student) => Padding(
                            padding:
                            const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: _StudentTile(
                              checkIn: student,
                            ),
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

  final String shiftType;


  const _Header({
    required this.shiftType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLecture = shiftType == "lecture";

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  isLecture
                      ? "lecture_shift".tr
                      : "housing_shift".tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLecture
                      ? "record_lecture_attendance".tr
                      : "record_housing_attendance".tr,
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              // QR Scanner
              _CircleIconButton(
                icon: Icons.qr_code_scanner_rounded,
                onTap: () async {

                  await Get.to(
                        () => const QrScannerView(),
                  );

                },
              ),


              const SizedBox(width: 10),


              // Attendance History
              _CircleIconButton(
                icon: Icons.history_rounded,
                onTap: () {

                  Get.to(
                        () => AttendanceHistoryView(
                     // shiftType: shiftType,
                    ),
                  );

                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: Padding(
          padding:
          const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Shift Card
// ---------------------------------------------------------------------------

class _ShiftCard extends StatelessWidget {
  final ShiftModel shift;

  const _ShiftCard({
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLecture =
        shift.shiftType == "lecture";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.light.withOpacity(.6),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding:
                const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent
                      .withOpacity(.18),
                  borderRadius:
                  BorderRadius.circular(14),
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      isLecture
                          ? "lecture".tr
                          : "housing".tr,
                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 17,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatDate(
                        shift.shiftDate,
                      ),
                      style:
                      TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),
                  ],
                ),
              ),

              if (shift.status != null)
                _StatusBadge(
                  status: shift.status!,
                ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Row(
              children: [

                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Text(
                  "${_formatTime(shift.fromHour)} - ${_formatTime(shift.toHour)}",
                  style:
                  TextStyle(
                    fontWeight:
                    FontWeight.w600,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
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

  const _StatusBadge({
    required this.status,
  });

  String get label {
    switch (status) {
      case "assigned":
        return "assigned".tr;

      case "completed":
        return "completed".tr;

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary
            .withOpacity(.18),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Summary Row
// ---------------------------------------------------------------------------

class _SummaryRow extends StatelessWidget {
  final CheckInSummaryModel summary;

  const _SummaryRow({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: _StatPill(
            label: "recorded".tr,
            value: summary.attendanceRecorded,
            color: _StatusColors.success,
            icon: Icons.check_circle_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatPill(
            label: "pending_scan".tr,
            value: summary.pendingScan,
            color: _StatusColors.pending,
            icon: Icons.hourglass_bottom_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _StatPill(
            label: "total_attendance".tr,
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
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(.25),
        ),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
            size: 20,
          ),

          const SizedBox(height: 6),

          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Students List
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final int count;

  const _SectionLabel({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "students".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$count",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentTile extends StatelessWidget {
  final StudentCheckInModel checkIn;

  const _StudentTile({
    required this.checkIn,
  });

  @override
  Widget build(BuildContext context) {
    final bool recorded = checkIn.attendanceRecorded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.light.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor:
            AppColors.light.withOpacity(.45),
            child: Text(
              _initials(
                checkIn.student.fullName,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  checkIn.student.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color:
                    Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  checkIn.student.studentIdentifier,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${"check_in_label".tr} : ${_formatTime(_timeFromDateTime(checkIn.checkInAt))}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: recorded
                  ? _StatusColors.success
                  .withOpacity(.15)
                  : _StatusColors.pending
                  .withOpacity(.15),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [

                Icon(
                  recorded
                      ? Icons.check_circle
                      : Icons.schedule,
                  size: 16,
                  color: recorded
                      ? _StatusColors.success
                      : _StatusColors.pending,
                ),

                const SizedBox(width: 5),

                Text(
                  recorded
                      ? "recorded".tr
                      : "pending".tr,
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 12,
                    color: recorded
                        ? _StatusColors.success
                        : _StatusColors.pending,
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
    final parts =
    name.trim().split(RegExp(r"\s+"));

    if (parts.isEmpty) return "?";

    if (parts.length == 1) {
      return parts.first[0];
    }

    return parts.first[0] + parts.last[0];
  }
}
// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyState({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.light.withOpacity(.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "no_current_shift".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "shift_will_appear_hint".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text("refresh".tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 28,
      ),
      alignment: Alignment.center,
      child: Text(
        "no_students_checked_in".tr,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 46,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text("retry".tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ---------------------------------------------------------------------------
// Formatting Helpers
// ---------------------------------------------------------------------------

String _formatTime(String hhmmss) {
  final parts = hhmmss.split(':');

  if (parts.length < 2) {
    return hhmmss;
  }

  final hour =
      int.tryParse(parts[0]) ?? 0;

  final minute = parts[1];

  final period =
  hour >= 12 ? "PM" : "AM";

  final hour12 =
  hour % 12 == 0 ? 12 : hour % 12;

  return "$hour12:$minute $period";
}


String _timeFromDateTime(String dateTime) {

  final parts =
  dateTime.split(' ');

  if (parts.length > 1) {
    return parts[1];
  }

  return dateTime;
}



String _formatDate(String date) {

  final cleanDate =
      date.split('T').first;

  final parts =
  cleanDate.split('-');


  if (parts.length != 3) {
    return date;
  }


  return "${parts[2]}/${parts[1]}/${parts[0]}";
}
