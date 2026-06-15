import 'package:get/get.dart';
import 'package:supervisors/models/ReportModel.dart';

import 'ReportsController.dart';

class ReportDetailsController
    extends GetxController {

  final ReportsController
  reportsController =
  Get.find<ReportsController>();

  Rxn<ReportModel> report =
  Rxn<ReportModel>();

  RxBool loading = false.obs;
  @override
  void onInit() {
    super.onInit();


    final int reportId =
        Get.arguments ?? 0;


    if(reportId != 0){

      loadReport(reportId);

    }

  }

  Future<void> loadReport(
      int reportId) async {

    loading(true);

    try {

      report.value =
      await reportsController
          .getReport(
        reportId,
      );

    } finally {

      loading(false);
    }
  }
}