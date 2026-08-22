import 'package:get/get.dart';
import 'package:supervisors/models/supervisor_shift_model.dart';
import 'package:supervisors/services/api_service.dart';

enum ShiftType {
  lecture,
  housing,
}

class SupervisorShiftsController extends GetxController {
  final ApiService _api = ApiService();

  // ======================================================
  // STATES
  // ======================================================

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // ======================================================
  // DATA
  // ======================================================

  final shifts = <ShiftDay>[].obs;

  // ======================================================
  // FILTERS
  // ======================================================

  final selectedType = ShiftType.lecture.obs;

  final selectedMonth = DateTime.now().obs;

  final selectedDate = DateTime.now().obs;

  // ======================================================
  // SHIFTS MAP
  // ======================================================

  final shiftsMap =
      <DateTime, List<SupervisorShift>>{}.obs;

  // ======================================================
  // INIT
  // ======================================================

  @override
  void onInit() {
    super.onInit();

    loadShifts();
  }

  // ======================================================
  // GET EVENTS
  // ======================================================

  List<SupervisorShift> getEventsForDay(DateTime day) {
    final key = DateTime(
      day.year,
      day.month,
      day.day,
    );

    return shiftsMap[key] ?? [];
  }

  // ======================================================
  // BUILD MAP
  // ======================================================

  void buildShiftsMap() {
    shiftsMap.clear();

    for (final day in shifts) {
      final date = DateTime.parse(day.date);

      final key = DateTime(
        date.year,
        date.month,
        date.day,
      );

      shiftsMap[key] = day.shifts;
    }
  }

  // ======================================================
  // SELECT DATE
  // ======================================================

  void selectDate(DateTime date) {
    selectedDate.value = DateTime(
      date.year,
      date.month,
      date.day,
    );

    update();
  }

  // ======================================================
  // SELECTED DAY SHIFTS
  // ======================================================

  List<SupervisorShift> get selectedDayShifts {
    return shiftsMap[selectedDate.value] ?? [];
  }

  // ======================================================
  // HAS SHIFT
  // ======================================================

  bool hasShift(DateTime day) {
    return getEventsForDay(day).isNotEmpty;
  }

  // ======================================================
  // SHIFT COUNT
  // ======================================================

  int shiftCount(DateTime day) {
    final date = DateTime(
      day.year,
      day.month,
      day.day,
    );

    return shiftsMap[date]?.length ?? 0;
  }

  // ======================================================
  // LOAD SHIFTS
  // ======================================================

  Future<void> loadShifts() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      update();

      final response = await _api.get(
        "/supervisor/my-shifts",
        queryParameters: {
          "page": 1,
          "per_page": 100,

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

      // ================================================
      // تحديد أول تاريخ فيه شفت
      // ================================================

      if (shifts.isNotEmpty) {
        final firstDate =
        DateTime.parse(shifts.first.date);

        selectedDate.value = DateTime(
          firstDate.year,
          firstDate.month,
          firstDate.day,
        );
      } else {
        selectedDate.value = DateTime(
          selectedMonth.value.year,
          selectedMonth.value.month,
          1,
        );
      }

      shiftsMap.refresh();

      // مهم جداً لـ GetBuilder
      update();

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      update();
    } finally {
      isLoading.value = false;

      update();
    }
  }

  // ======================================================
  // CHANGE SHIFT TYPE
  // ======================================================

  Future<void> changeType(ShiftType type) async {
    if (selectedType.value == type) {
      return;
    }

    selectedType.value = type;

    shifts.clear();
    shiftsMap.clear();

    update();

    await loadShifts();
  }

  // ======================================================
  // NEXT MONTH
  // ======================================================

  Future<void> nextMonth() async {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );

    await loadShifts();
  }

  // ======================================================
  // PREVIOUS MONTH
  // ======================================================

  Future<void> previousMonth() async {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );

    await loadShifts();
  }

  // ======================================================
  // MONTH STRING
  // ======================================================

  String get monthString {
    final month =
    selectedMonth.value.month
        .toString()
        .padLeft(2, '0');

    return "${selectedMonth.value.year}-$month";
  }

  // ======================================================
  // REFRESH
  // ======================================================

  Future<void> refreshPage() async {
    await loadShifts();
  }
}