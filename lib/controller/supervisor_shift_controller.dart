import 'package:get/get.dart';
import 'package:supervisors/models/supervisor_shift_model.dart';
import 'package:supervisors/services/api_service.dart';


enum ShiftType {
  lecture,
  housing,
}

class SupervisorShiftsController extends GetxController {
  final ApiService _api = ApiService();

  ///=========================
  /// STATES
  ///=========================

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  ///=========================
  /// DATA
  ///=========================

  final shifts = <ShiftDay>[].obs;

  ///=========================
  /// FILTERS
  ///=========================

  final selectedType = ShiftType.lecture.obs;

  final selectedMonth = DateTime.now().obs;

  /// Selected Day in Calendar
  final selectedDate = DateTime.now().obs;

  /// All shifts grouped by date
  final shiftsMap = <DateTime, List<SupervisorShift>>{}.obs;
  List<SupervisorShift> getEventsForDay(DateTime day) {

    final key = DateTime(
      day.year,
      day.month,
      day.day,
    );

    return shiftsMap[key] ?? [];
  }



  ///=========================
  /// INIT
  ///=========================

  @override
  void onInit() {
    super.onInit();
    loadShifts();
  }

  ///=========================
  /// API
  ///=========================

  void buildShiftsMap() {
    shiftsMap.clear();

    for (final day in shifts) {
      final date = DateTime.parse(day.date);

      shiftsMap[DateTime(date.year, date.month, date.day)] = day.shifts;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  List<SupervisorShift> get selectedDayShifts {
    return shiftsMap[selectedDate.value] ?? [];
  }

  bool hasShift(DateTime day) {

    return getEventsForDay(day).isNotEmpty;

  }

  int shiftCount(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);

    return shiftsMap[date]?.length ?? 0;
  }

  Future<void> loadShifts() async {
    try {
      isLoading(true);
      hasError(false);

      final response = await _api.get(
        "/supervisor/my-shifts",
        queryParameters: {
          "page": 1,
          "per_page": 20,
          "shift_type":
          selectedType.value == ShiftType.lecture
              ? "lecture"
              : "housing",
          "month": monthString,
        },
      );

      final result =
      SupervisorShiftsResponse.fromJson(response);

      shifts.assignAll(result.data);

      buildShiftsMap();

      /// إذا أول مرة يدخل الصفحة
      if (shifts.isNotEmpty) {
        final firstDate = DateTime.parse(shifts.first.date);

        selectedDate.value = DateTime(
          firstDate.year,
          firstDate.month,
          firstDate.day,
        );
      } else {
        // إذا لا يوجد شفتات في هذا الشهر
        selectedDate.value = DateTime(
          selectedMonth.value.year,
          selectedMonth.value.month,
          1,
        );
      }

    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  ///=========================
  /// TAB
  ///=========================

  void changeType(ShiftType type) {
    if (selectedType.value == type) return;

    selectedType(type);

    loadShifts();
  }

  ///=========================
  /// MONTH
  ///=========================

  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );

    loadShifts();
  }

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );

    loadShifts();
  }

  String get monthString {
    final month =
    selectedMonth.value.month.toString().padLeft(2, '0');

    return "${selectedMonth.value.year}-$month";
  }

  ///=========================
  /// REFRESH
  ///=========================

  Future<void> refreshPage() async {
    await loadShifts();
  }
}