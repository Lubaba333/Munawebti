import 'package:get/get.dart';
import 'package:supervisors/models/ReportModel.dart';
import 'package:supervisors/services/api_service.dart';


class ReportsController extends GetxController {

  final ApiService api = ApiService();

  RxList<ReportModel> reports =
      <ReportModel>[].obs;

  RxBool loading = false.obs;

  Future<void> getStudentReports(
      int studentId) async {

    loading(true);

    try {

      final response =
      await api.get(
        '/supervisor/student-reports',
      );

      final List list =
      response['data']['data'];

      reports.value = list
          .where(
            (e) =>
        e['student_id'] ==
            studentId,
      )
          .map(
            (e) =>
            ReportModel.fromJson(e),
      )
          .toList();

    } catch (e) {

      Get.snackbar(
        "خطأ",
        e.toString(),
      );

    } finally {

      loading(false);
    }
  }

  Future<ReportModel> getReport(
      int reportId) async {

    final response =
    await api.get(
      '/supervisor/student-reports/$reportId',
    );

    return ReportModel.fromJson(
      response['data'],
    );
  }

  Future<void> updateReport({
    required int reportId,
    required String notes,
  }) async {

    await api.put(
      '/supervisor/student-reports/$reportId',
      {
        "notes": notes,
      },
    );

    Get.snackbar(
      "نجاح",
      "تم تعديل التقرير",
    );
  }

  Future<void> deleteReport(
      int reportId) async {

    await api.delete(
      '/supervisor/student-reports/$reportId',
    );

    reports.removeWhere(
          (e) => e.id == reportId,
    );

    Get.snackbar(
      "نجاح",
      "تم حذف التقرير",
    );
  }
}