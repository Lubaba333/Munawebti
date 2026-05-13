import 'package:get/get.dart';

class SwapController extends GetxController {
  var myShift = {}.obs;

  var availableShifts = <Map<String, dynamic>>[].obs;

  var selectedShift = Rxn<Map<String, dynamic>>();

  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockShifts();
  }

  void setMyShift(Map shift) {
    myShift.value = shift;
  }

  void loadMockShifts() {
    availableShifts.value = [
      {
        "supervisor": "Lina",
        "time": "08:00 - 02:00",
        "location": "Hospital"
      },
      {
        "supervisor": "Maya",
        "time": "08:00 - 02:00",
        "location": "Hospital"
      },
    ];
  }

  void selectShift(Map shift) {
   // selectedShift.value = shift;
  }

  void submitRequest() {
    if (selectedShift.value == null) {
      Get.snackbar("Error", "Select a shift first");
      return;
    }

    isSubmitting.value = true;

    Future.delayed(Duration(seconds: 1), () {
      isSubmitting.value = false;

      Get.back();

      Get.snackbar("Success", "Swap Request Sent 🔁");
    });
  }
}