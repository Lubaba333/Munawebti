import 'package:get/get.dart';
import 'package:studants/controllers/lecture_controller.dart';

class HomeController extends GetxController {
  var studentName = "".obs;

  var hospital = "جاري تحميل المحاضرة القادمة...".obs;
  var day = "".obs;
  var time = "".obs;
  var location = "".obs;

  var notificationCount = 0.obs;

  late final LectureController lectureController;

  @override
  void onInit() {
    super.onInit();

    studentName.value = "Lina Ahmed";
    notificationCount.value = 0;

    lectureController = Get.isRegistered<LectureController>()
        ? Get.find<LectureController>()
        : Get.put(LectureController());

    ever(lectureController.lectures, (_) {
      _calculateNextLecture();
    });

    loadNextLecture();
  }

  Future<void> loadNextLecture() async {
    await lectureController.getLectures();
    _calculateNextLecture();
  }

  void _calculateNextLecture() {
    final lectures = lectureController.lectures;

    if (lectures.isEmpty) {
      hospital.value = "لا توجد محاضرات قادمة";
      day.value = "";
      time.value = "";
      location.value = "";
      return;
    }

    final now = DateTime.now();

    DateTime? nearestDate;
    dynamic nearestLecture;

    for (final lecture in lectures) {
      final lectureDay = _dayNumber(lecture.day.trim());
      final startTime = _parseTime(lecture.fromHour.trim());

      if (lectureDay == null || startTime == null) continue;

      int diff = lectureDay - now.weekday;
      if (diff < 0) diff += 7;

      var lectureDate = DateTime(
        now.year,
        now.month,
        now.day + diff,
        startTime.hour,
        startTime.minute,
      );

      if (lectureDate.isBefore(now)) {
        lectureDate = lectureDate.add(const Duration(days: 7));
      }

      if (nearestDate == null || lectureDate.isBefore(nearestDate)) {
        nearestDate = lectureDate;
        nearestLecture = lecture;
      }
    }

    if (nearestLecture == null) {
      hospital.value = "لا توجد محاضرات قادمة";
      day.value = "";
      time.value = "";
      location.value = "";
      return;
    }

    hospital.value = nearestLecture.subjectName;
    day.value = _arabicDay(nearestLecture.day);
    time.value =
        "${_formatTime(nearestLecture.fromHour)} - ${_formatTime(nearestLecture.toHour)}";
    location.value = nearestLecture.labName;
  }

  int? _dayNumber(String day) {
    switch (day) {
      case "Monday":
      case "الاثنين":
        return 1;
      case "Tuesday":
      case "الثلاثاء":
        return 2;
      case "Wednesday":
      case "الأربعاء":
        return 3;
      case "Thursday":
      case "الخميس":
        return 4;
      case "Friday":
      case "الجمعة":
        return 5;
      case "Saturday":
      case "السبت":
        return 6;
      case "Sunday":
      case "الأحد":
        return 7;
      default:
        return null;
    }
  }

  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(":");
      return DateTime(
        2000,
        1,
        1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  String _formatTime(String time) {
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  String _arabicDay(String day) {
    switch (day.trim()) {
      case "Sunday":
        return "الأحد";
      case "Monday":
        return "الاثنين";
      case "Tuesday":
        return "الثلاثاء";
      case "Wednesday":
        return "الأربعاء";
      case "Thursday":
        return "الخميس";
      case "Friday":
        return "الجمعة";
      case "Saturday":
        return "السبت";
      default:
        return day;
    }
  }
}