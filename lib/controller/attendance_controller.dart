// import 'package:get/get.dart';
// import '../services/api_service.dart';
// import '../models/upcoming_shift_model.dart';
// import '../models/shift_check_ins_model.dart';
//
// class AttendanceController extends GetxController {
//
//   final ApiService apiService = ApiService();
//
//   // final AttendanceController attendanceController = Get.find<AttendanceController>();
//
//   // ----- Upcoming shift -----
//   final Rxn<UpcomingShiftModel> upcomingShift = Rxn<UpcomingShiftModel>();
//   final RxBool isLoadingShift = false.obs;
//
//   // ----- Shift check-ins (students) -----
//   final RxList<StudentCheckInModel> students = <StudentCheckInModel>[].obs;
//   final RxBool isLoadingCheckIns = false.obs;
//   final Rxn<CheckInsSummaryModel> checkInsSummary = Rxn<CheckInsSummaryModel>();
//
//   final RxString errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUpcomingShift();
//   }
//
//   /// GET /supervisor/attendance/upcoming-shift-with-check-ins
//   /// يجيب الشيفت القادم، وإذا موجود بينادي مباشرة على تفاصيل الـ check-ins تبعو
//   Future<void> loadUpcomingShift({String? shiftType}) async {
//     try {
//       isLoadingShift.value = true;
//       errorMessage.value = '';
//
//       final response = await apiService.get(
//         '/supervisor/attendance/upcoming-shift-with-check-ins',
//         queryParameters: shiftType != null ? {'shift_type': shiftType} : null,
//       );
//
//       final data = response['data'];
//
//       if (data != null) {
//         upcomingShift.value = UpcomingShiftModel.fromJson(data);
//         await loadShiftCheckIns(upcomingShift.value!.shift.id);
//       } else {
//         upcomingShift.value = null;
//         students.clear();
//         checkInsSummary.value = null;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString().replaceFirst('Exception: ', '');
//     } finally {
//       isLoadingShift.value = false;
//     }
//   }
//
//   /// GET /supervisor/attendance/shift/{shiftId}/check-ins
//   /// يجيب لائحة الطلاب المسجلين check-in لشيفت معين
//   Future<void> loadShiftCheckIns(int shiftId) async {
//     try {
//       isLoadingCheckIns.value = true;
//
//       final response = await apiService.get(
//         '/supervisor/attendance/shift/$shiftId/check-ins',
//       );
//
//       final result = ShiftCheckInsModel.fromJson(response['data']);
//
//       students.assignAll(result.students);
//       checkInsSummary.value = result.summary;
//     } catch (e) {
//       errorMessage.value = e.toString().replaceFirst('Exception: ', '');
//     } finally {
//       isLoadingCheckIns.value = false;
//     }
//   }
//
//   /// لتحديث الشاشة (Pull to refresh)
//   /// هاد التابع كمان بينادى من QrScannerController بعد نجاح السكان
//   /// عشان يحدّث لائحة الطلاب والملخص تلقائياً
//   Future<void> refresh() async {
//     await loadUpcomingShift();
//   }
// }







import 'package:get/get.dart';
import '../models/shift_check_ins_model.dart';
import '../models/upcoming_shift_model.dart';
import '../services/api_service.dart';

class AttendanceController extends GetxController {
  final ApiService _apiService;

  /// lecture أو housing
  final String shiftType;

  AttendanceController(
      this._apiService,
      this.shiftType,
      );

  //---------------------------------------
  // Upcoming Shift
  //---------------------------------------

  final Rxn<UpcomingShiftModel> upcomingShift =
  Rxn<UpcomingShiftModel>();

  final RxBool isLoadingShift = false.obs;

  //---------------------------------------
  // Students
  //---------------------------------------

  final RxList<StudentCheckInModel> students =
      <StudentCheckInModel>[].obs;

  final RxBool isLoadingCheckIns =
      false.obs;

  final Rxn<CheckInsSummaryModel> checkInsSummary =
  Rxn<CheckInsSummaryModel>();

  final RxString errorMessage =
      ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUpcomingShift();
  }

  //--------------------------------------------------------
  // Upcoming Shift
  //--------------------------------------------------------

  Future<void> loadUpcomingShift() async {
    try {
      isLoadingShift.value = true;
      errorMessage.value = '';

      final response = await _apiService.get(
        "/supervisor/attendance/upcoming-shift-with-check-ins",
        queryParameters: {
          "shift_type": shiftType,
        },
      );

      final data = response["data"];

      if (data != null) {
        upcomingShift.value =
            UpcomingShiftModel.fromJson(data);

        await loadShiftCheckIns(
          upcomingShift.value!.shift.id,
        );
      } else {
        upcomingShift.value = null;
        students.clear();
        checkInsSummary.value = null;
      }
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
            "Exception: ",
            "",
          );
    } finally {
      isLoadingShift.value = false;
    }
  }

  //--------------------------------------------------------
  // Students Check-ins
  //--------------------------------------------------------

  Future<void> loadShiftCheckIns(
      int shiftId,
      ) async {
    try {
      isLoadingCheckIns.value = true;

      final response = await _apiService.get(
        "/supervisor/attendance/shift/$shiftId/check-ins",
      );

      final result =
      ShiftCheckInsModel.fromJson(
        response["data"],
      );

      students.assignAll(
        result.students,
      );

      checkInsSummary.value =
          result.summary;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst(
            "Exception: ",
            "",
          );
    } finally {
      isLoadingCheckIns.value = false;
    }
  }

  //--------------------------------------------------------
  // Refresh
  //--------------------------------------------------------

  Future<void> refresh() async {
    await loadUpcomingShift();
  }
}