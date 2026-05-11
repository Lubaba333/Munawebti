import 'package:get/get.dart';
import 'package:studants/models/room_request_model.dart';
import 'package:studants/services/service.dart';


class HousingController extends GetxController {
  final ApiService api = ApiService();

  var isLoading = false.obs;

  /// 🔴 الطالبة المختارة
  var selectedStudentId = RxnInt();

  /// 🟡 Mock Data (لاحقاً من API)
  var students = [
    {"id": 1, "name": "Lina A.", "room": 203},
    {"id": 2, "name": "Sara M.", "room": 105},
    {"id": 3, "name": "Noor K.", "room": 110},
  ].obs;

  Future<void> sendSwapRequest(String reason) async {
    if (selectedStudentId.value == null) {
      Get.snackbar("Error", "Please select a student");
      return;
    }

    try {
      isLoading.value = true;

      final request = RoomRequestModel(
        type: "swap",
        reason: reason,
        swapStudentId: selectedStudentId.value,
      );

      await api.post('/room-requests', request.toJson());

      Get.snackbar("Success", "Swap request sent");
      Get.back();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}