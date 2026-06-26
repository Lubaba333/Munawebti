import 'package:flutter/material.dart';
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
          color: Colors.white,
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

              final shifts =
              controller.getEventsForDay(selectedDay);

              if (shifts.isEmpty) return;

              showModalBottomSheet(

                context: context,

                isScrollControlled: true,

                backgroundColor: Colors.transparent,

                builder: (_) => ShiftBottomSheet(
                  shifts: shifts,
                ),
              );
            },
            // calendarBuilders: CalendarBuilders(
            //
            //   markerBuilder: (context, day, events) {
            //
            //     if (events.isEmpty) {
            //       return const SizedBox();
            //     }
            //
            //     return Positioned(
            //
            //       bottom: 5,
            //
            //       child: Container(
            //
            //         width: 8,
            //
            //         height: 8,
            //
            //         decoration: const BoxDecoration(
            //
            //           color: Color(0xFFA467A7),
            //
            //           shape: BoxShape.circle,
            //
            //         ),
            //       ),
            //     );
            //   },
            // ),

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

                      shifts.length > 3
                          ? 3
                          : shifts.length,

                          (index) {

                        final shift = shifts[index];

                        final markerColor =
                        shift.shiftType == "lecture"
                            ? const Color(0xFFA467A7)
                            : Colors.blue;

                        return Container(
                          margin:
                          const EdgeInsets.symmetric(
                            horizontal: 1,
                          ),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(

              outsideDaysVisible: false,

              todayDecoration: const BoxDecoration(

                color: Color(0xFFC28DBD),

                shape: BoxShape.circle,

              ),

              selectedDecoration: const BoxDecoration(

                color: Color(0xFFA467A7),

                shape: BoxShape.circle,

              ),

              markerDecoration: const BoxDecoration(

                color: Color(0xFFA467A7),

                shape: BoxShape.circle,

              ),

            ),
          ),
        ),
      );
    }
    );
  }
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
      decoration: const BoxDecoration(
        color: background,
        borderRadius: BorderRadius.vertical(
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
                  color: Colors.grey.shade700,
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
                        color: Colors.white,
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
                                      ? "Lecture"
                                      : "Housing",
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
                                "Lecture"
                                : housing?.dormitoryName ??
                                "Housing",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),

                          const SizedBox(height: 22),

                          _infoTile(
                            Icons.schedule,
                            "Time",
                            "${_time(shift.startTime)} - ${_time(shift.endTime)}",
                          ),

                          if (isLecture) ...[

                            _infoTile(
                              Icons.person_outline,
                              "Lecturer",
                              lecture?.teacherName ??
                                  "-",
                            ),

                            _infoTile(
                              Icons.location_on_outlined,
                              "Location",
                              lecture?.labName ??
                                  "No Lab",
                            ),

                            _infoTile(
                              Icons.school_outlined,
                              "Class",
                              "${lecture?.specialization}\nYear ${lecture?.year} • Branch ${lecture?.branch}",
                            ),

                          ] else ...[

                            _infoTile(
                              Icons.home_work_outlined,
                              "Dormitory",
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
                              label: const Text(
                                "Take Attendance",
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
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
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
                    color: Colors.grey.shade700,
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

    switch (status.toLowerCase()) {

      case "assigned":
        color = Colors.green;
        break;

      case "completed":
        color = Colors.blue;
        break;

      case "cancelled":
        color = Colors.red;
        break;

      default:
        color = Colors.orange;
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
        status.toUpperCase(),
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

    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${date.day} ${months[date.month]} ${date.year}";
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