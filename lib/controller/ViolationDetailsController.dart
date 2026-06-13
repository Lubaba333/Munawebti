import 'package:get/get.dart';
import 'package:supervisors/controller/ViolationsController.dart';
import 'package:supervisors/models/ViolationModel.dart';



class ViolationDetailsController
    extends GetxController {

  final ViolationsController
  violationsController =
  Get.find<
      ViolationsController>();

  Rxn<ViolationModel>
  violation =
  Rxn<ViolationModel>();

  RxBool loading =
      false.obs;

  @override
  void onInit() {
    super.onInit();

    final int violationId =
        Get.arguments;

    loadViolation(
      violationId,
    );
  }

  Future<void> loadViolation(
      int violationId) async {

    loading(true);

    try {

      violation.value =
      await violationsController
          .getViolation(
        violationId,
      );

    } finally {

      loading(false);
    }
  }
}