import 'package:get/get.dart';

class Schedule {
  final String id;
  final String name;
  final String createdAt;

  Schedule({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class ScheduleListController extends GetxController {
  var schedules = <Schedule>[
    Schedule(id: "1", name: "Week 1", createdAt: "12 May"),
    Schedule(id: "1", name: "Week 1", createdAt: "12 May"),
    Schedule(id: "2", name: "Exam Schedule", createdAt: "20 May"),
    Schedule(id: "1", name: "Week 1", createdAt: "12 May"),
    Schedule(id: "2", name: "Exam Schedule", createdAt: "20 May"),
    Schedule(id: "2", name: "Exam Schedule", createdAt: "20 May"),
  ].obs;

  /// 🔥 FILTERS
  var selectedMonth = Rxn<int>();
  var selectedYear = Rxn<int>();

  /// 🔥 FILTERED LIST
  List<Schedule> get filteredSchedules {
    return schedules.where((schedule) {
      DateTime date = _parseDate(schedule.createdAt);

      bool matchMonth = selectedMonth.value == null ||
          date.month == selectedMonth.value;

      bool matchYear = selectedYear.value == null ||
          date.year == selectedYear.value;

      return matchMonth && matchYear;
    }).toList();
  }

  void addSchedule(Schedule schedule) {
    schedules.add(schedule);
  }

  void deleteSchedule(int index) {
    schedules.removeAt(index);
  }

  /// 🔥 PARSE DATE
  DateTime _parseDate(String text) {
    try {
      List<String> parts = text.split(" ");
      int day = int.parse(parts[0]);
      String monthStr = parts[1];

      int month = _monthToNumber(monthStr);

      return DateTime(DateTime.now().year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  int _monthToNumber(String month) {
    const months = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12,
    };

    return months[month] ?? 1;
  }
}