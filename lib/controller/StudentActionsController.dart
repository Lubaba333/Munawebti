import 'package:get/get.dart';
import 'package:supervisors/services/api_service.dart';


class StudentActionsController extends GetxController {

  final ApiService _api = ApiService();

  RxBool loading = false.obs;

  Future<void> createWarning({
    required int studentId,
    required String title,
    required String description,
    required String warningDate,
    required String possiblePenalty,
  }) async {

    loading(true);

    try {

      print("=== CREATE WARNING START ===");
      print("studentId = $studentId");
      print("title = $title");
      print("description = $description");
      print("warningDate = $warningDate");
      print("possiblePenalty = $possiblePenalty");


      await _api.post(
        '/supervisor/warnings',
        {
          "target_type": "student",
          "target_id": studentId,
          "title": title,
          "description": description,
          "warning_date": warningDate,
          "possible_penalty": possiblePenalty,
        },
      );
      print("=== CREATE WARNING SUCCESS ===");

      Get.back();

      Get.snackbar(
        "نجاح",
        "تم إضافة التحذير بنجاح",
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }
  Future<void> createViolation({
    required int studentId,
    required String title,
    required String description,
    required String violationDate,
    required String category,
    required String penalty,
  }) async {

    loading(true);
    print("نجاح" "تمت إضافة المخالفة");
    try {

      await _api.post(
        '/supervisor/violations',
        {
          "target_type": "student",
          "target_id": studentId,
          "title": title,
          "description": description,
          "violation_date": violationDate,
          "category": category,
          "penalty": penalty,
        },
      );

      Get.back();

      Get.snackbar(
        "نجاح",
        "تمت إضافة المخالفة",
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }
  Future<void> createReward({
    required int studentId,
    required String rewardType,
    required String title,
    required String description,
    required String rewardDate,
    required int points,
  }) async {

    loading(true);

    try {

      await _api.post(
        '/supervisor/rewards',
        {
          "target_type": "student",
          "target_id": studentId,
          "reward_type": rewardType,
          "title": title,
          "description": description,
          "reward_date": rewardDate,
          "points": points,
        },
      );

      Get.back();

      Get.snackbar(
        "نجاح",
        "تمت إضافة المكافأة",
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }
  Future<void> createReport({
    required int studentId,
    required String reportType,
    required String description,
    required String reportDate,
    required String notes,
  }) async {

    loading(true);

    try {

      await _api.post(
        '/supervisor/student-reports',
        {
          "student_id": studentId,
          "report_type": reportType,
          "description": description,
          "report_date": reportDate,
          "notes": notes,
        },
      );

      Get.back();

      Get.snackbar(
        "نجاح",
        "تم إضافة التقرير",
      );

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }

}