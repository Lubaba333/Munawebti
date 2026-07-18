import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/supervisor_shift_controller.dart';
import 'package:supervisors/models/supervisor_shift_model.dart';
import 'package:table_calendar/table_calendar.dart';


class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({super.key});

  static const Color primary = Color(0xFFA467A7);
  static const Color secondary = Color(0xFFC28DBD);
  static const Color light = Color(0xFFDBB9D7);
  static const Color background = Color(0xFFF5EFE7);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupervisorShiftsController>();

    return Obx(() {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: TableCalendar<SupervisorShift>(
            key: ValueKey(
              "${controller.selectedType.value}-${controller.monthString}",
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            firstDay: DateTime(2025),

            lastDay: DateTime(2030),

            focusedDay: controller.selectedMonth.value,

            selectedDayPredicate: (day) {

              return isSameDay(
                controller.selectedDate.value,
                day,
              );

            },

            eventLoader: (day) {

              return controller.getEventsForDay(day);

            },
            onDaySelected: (selectedDay, focusedDay) {
              controller.selectDate(selectedDay);

              final shifts = controller.getEventsForDay(selectedDay);
              if (shifts.isEmpty) return;

              Future.delayed(const Duration(milliseconds: 120), () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ShiftBottomSheet(
                    shifts: shifts,
                  ),
                );
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {

                final shifts =
                controller.getEventsForDay(date);

                if (shifts.isEmpty) {
                  return const SizedBox();
                }

                return Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      shifts.length > 3 ? 3 : shifts.length,
                          (index) {
                        final shift = shifts[index];

                        final markerColor =
                        shift.shiftType == "lecture"
                            ? const Color(0xFFA467A7)
                            : Colors.blue;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: markerColor.withOpacity(.45),
                                blurRadius: 6,
                              )
                            ],
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                          begin: const Offset(.9, .9),
                          end: const Offset(1.15, 1.15),
                          duration: 900.ms,
                        );
                      },
                    ),
                  ),
                );
              },

              defaultBuilder: (context, day, focusedDay) {

                final hasShift =
                    controller.getEventsForDay(day).isNotEmpty;

                return _dayCell(
                  context: context,
                  day: day,
                  selected: false,
                  today: false,
                  hasShift: hasShift,
                  selectedType: controller.selectedType.value,
                );
              },

              todayBuilder: (context, day, focusedDay) {

                final hasShift =
                    controller.getEventsForDay(day).isNotEmpty;

                return _dayCell(
                  context: context,
                  day: day,
                  selected: false,
                  today: true,
                  hasShift: hasShift,
                  selectedType: controller.selectedType.value,
                );
              },
              selectedBuilder: (context, day, focusedDay) {

                final hasShift =
                    controller.getEventsForDay(day).isNotEmpty;

                return _dayCell(
                  context: context,
                  day: day,
                  selected: false,
                  today: false,
                  hasShift: hasShift,
                  selectedType: controller.selectedType.value,
                );
              },
            ),
            calendarStyle: CalendarStyle(

              outsideDaysVisible: false,


            ),
          ),
        ),
      );
    }
    );
  }
}

Widget _dayCell({
  required BuildContext context,
  required DateTime day,
  required bool selected,
  required bool today,
  required bool hasShift,
  required ShiftType selectedType,
}) {
  final primary =
  selectedType == ShiftType.lecture
      ? const Color(0xFFA467A7)
      : Colors.blue;

  final light =
  selectedType == ShiftType.lecture
      ? const Color(0xFFDBB9D7)
      : const Color(0xFFD6E9FF);

  Color background = Colors.transparent;
  Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

  if (selected) {
    background = primary;
    textColor = Colors.white;
  } else if (today) {
    background = light;
  } else if (hasShift) {
    background = primary.withOpacity(.10);
  }

  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
      border: hasShift && !selected
          ? Border.all(
          color: primary.withOpacity(.08),
          width: 1
      )
          : null,
    ),
    child: Center(
      child: Text(
        "${day.day}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    ),
  );
}

class ShiftBottomSheet extends StatelessWidget {
  final List<SupervisorShift> shifts;

  const ShiftBottomSheet({
    super.key,
    required this.shifts,
  });

  static const Color primary = Color(0xFFA467A7);
  static const Color secondary = Color(0xFFC28DBD);
  static const Color light = Color(0xFFDBB9D7);
  static const Color background = Color(0xFFF5EFE7);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Handle
              Container(
                width: 55,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              const SizedBox(height: 20),

              /// Day
              Text(
                shifts.first.day,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _formatDate(shifts.first.shiftDate),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 28),

              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: shifts.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 18),
                  itemBuilder: (_, index) {

                    final shift = shifts[index];

                    final lecture =
                        shift.lectureAssignment;

                    final housing =
                        shift.housingAssignment;

                    final isLecture =
                        shift.shiftType == "lecture";

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                        BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(.10),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          ///==========================
                          /// Header
                          ///==========================

                          Row(
                            children: [

                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: isLecture
                                      ? primary.withOpacity(.12)
                                      : Colors.blue
                                      .withOpacity(.12),
                                  borderRadius:
                                  BorderRadius.circular(25),
                                ),
                                child: Text(
                                  isLecture
                                      ? "lecture".tr
                                      : "housing".tr,
                                  style: TextStyle(
                                    color: isLecture
                                        ? primary
                                        : Colors.blue,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              _statusChip(
                                shift.status,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            isLecture
                                ? lecture?.subjectName ??
                                "lecture".tr
                                : housing?.dormitoryName ??
                                "housing".tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),

                          const SizedBox(height: 22),

                          _infoTile(
                            context,
                            Icons.schedule,
                            "time".tr,
                            "${_time(shift.startTime)} - ${_time(shift.endTime)}",
                          ),

                          if (isLecture) ...[

                            _infoTile(
                              context,
                              Icons.person_outline,
                              "lecturer".tr,
                              lecture?.teacherName ??
                                  "-",
                            ),

                            _infoTile(
                              context,
                              Icons.location_on_outlined,
                              "location".tr,
                              lecture?.labName ??
                                  "no_lab".tr,
                            ),

                            _infoTile(
                              context,
                              Icons.school_outlined,
                              "class_label".tr,
                              "${lecture?.specialization}\n${"year".tr} ${lecture?.year} • ${"branch".tr} ${lecture?.branch}",
                            ),

                          ] else ...[

                            _infoTile(
                              context,
                              Icons.home_work_outlined,
                              "dormitory".tr,
                              housing?.dormitoryName ??
                                  "",
                            ),

                          ],

                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: () {

                                Get.back();

                                print(
                                    "Shift ${shift.id}");

                              },
                              icon: const Icon(
                                Icons.fact_check,
                                color: Colors.white,
                              ),
                              label:  Text(
                                "take_attendance".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style:
                              ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primary,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _infoTile(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primary.withOpacity(.15),
            child: Icon(
              icon,
              color: primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {

    Color color;
    String translatedStatus;

    switch (status.toLowerCase()) {

      case "assigned":
        color = Colors.green;
        translatedStatus = "assigned".tr;
        break;

      case "completed":
        color = Colors.blue;
        translatedStatus = "completed".tr;
        break;

      case "cancelled":
        color = Colors.red;
        translatedStatus = "cancelled".tr;
        break;

      default:
        color = Colors.orange;
        translatedStatus = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        translatedStatus,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(String value) {

    final date = DateTime.parse(value);

    const monthKeys = [
      "",
      "month_1",
      "month_2",
      "month_3",
      "month_4",
      "month_5",
      "month_6",
      "month_7",
      "month_8",
      "month_9",
      "month_10",
      "month_11",
      "month_12",
    ];

    return "${date.day} ${monthKeys[date.month].tr} ${date.year}";
  }

  String _time(String value) {

    if (value.isEmpty) {
      return "--:--";
    }

    return value.length >= 5
        ? value.substring(0, 5)
        : value;
  }
}



class ShiftLegend extends StatelessWidget {
  const ShiftLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          _LegendItem(
            color: const Color(0xFFA467A7),
            title: "lecture_shift".tr,
            icon: Icons.school_rounded,
          ),

          const SizedBox(
            height: 28,
            child: VerticalDivider(),
          ),

          _LegendItem(
            color: Colors.blue,
            title: "housing_shift".tr,
            icon: Icons.home_work_rounded,
          ),
        ],
      ),
    )
        .animate()
        .fade(duration: 500.ms)
        .slideY(
      begin: .25,
      end: 0,
      curve: Curves.easeOut,
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}