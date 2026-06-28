import 'package:get/get.dart';
import 'package:supervisors/controller/ReportsController.dart';
import 'package:supervisors/controller/RewardsController.dart';
import 'package:supervisors/controller/ViolationsController.dart';
import 'package:supervisors/controller/warning_controller.dart';
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


      final warningsController =
      Get.find<WarningsController>();


      await warningsController
          .getStudentWarnings(studentId);

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

      final controller =
      Get.find<ViolationsController>();

      await controller.getStudentViolations(studentId);

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
      final rewardsController =
      Get.find<RewardsController>();

      await rewardsController
          .getStudentRewards(studentId);

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

      final reportsController =
      Get.find<ReportsController>();


      await reportsController.getStudentReports(
        studentId,
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