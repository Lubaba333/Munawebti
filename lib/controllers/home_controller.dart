import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  var studentName = "".obs;

  var hospital = "جاري تحميل المحاضرة القادمة...".obs;
  var day = "".obs;
  var time = "".obs;
  var location = "".obs;

  var notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    studentName.value = "Lina Ahmed";
    notificationCount.value = 0;

    loadNextLecture();
  }

  Future<void> loadNextLecture() async {
    try {
      final res = await _apiService.get(
        '/student/attendance/upcoming-shift',
        queryParameters: {'shift_type': 'lecture'},
        authRequired: true,
      );

      final shift = res?['data']?['shift'];
      final shiftDetails = res?['data']?['shift_details'];

      if (shift == null) {
        _resetToEmpty();
        return;
      }

      hospital.value = shiftDetails?['subject_name'] ?? "عنوان المحاضرة";
      day.value = _formatDayAndDate(
        shift['shift_date'] ?? '',
        shift['day'] ?? '',
      );
      time.value =
          "${_formatTime(shift['from_hour'] ?? '')} - ${_formatTime(shift['to_hour'] ?? '')}";
      location.value = shiftDetails?['location'] ?? '';
    } catch (e) {
      _resetToEmpty();
    }
  }

  void _resetToEmpty() {
    hospital.value = "لا توجد محاضرات قادمة";
    day.value = "";
    time.value = "";
    location.value = "";
  }

  String _formatDayAndDate(String date, String day) {
    if (date.isEmpty && day.isEmpty) return '';
    final arabicDay = _arabicDay(day);
    return date.isNotEmpty ? "$date - $arabicDay" : arabicDay;
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