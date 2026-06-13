import 'package:get/get.dart';
import 'package:supervisors/controller/warning_controller.dart';
import 'package:supervisors/models/WarningModel.dart';

class WarningDetailsController extends GetxController {

  final WarningsController warningsController =
  Get.find<WarningsController>();

  final Rxn<WarningModel> warning =
  Rxn<WarningModel>();

  final RxBool loading =
      false.obs;

  @override
  void onInit() {
    super.onInit();

    final int warningId =
    Get.arguments as int;

    loadWarning(warningId);
  }

  Future<void> loadWarning(
      int warningId) async {

    try {

      loading(true);

      final result =
      await warningsController.getWarning(
        warningId,
      );

      warning.value = result;

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