import 'package:get/get.dart';

import '../models/attendance_history_model.dart';
import '../services/api_service.dart';


class AttendanceHistoryController extends GetxController {
  final ApiService apiService;

  AttendanceHistoryController(this.apiService);

  final RxList<AttendanceHistoryModel> history =
      <AttendanceHistoryModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory({
    int page = 1,
    int perPage = 15,
    String? shiftType,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> query = {
        "page": page,
        "per_page": perPage,
      };

      if (shiftType != null) {
        query["shift_type"] = shiftType;
      }

      if (dateFrom != null) {
        query["date_from"] = dateFrom;
      }

      if (dateTo != null) {
        query["date_to"] = dateTo;
      }

      final response = await apiService.get(
        "/supervisor/attendance/history",
        queryParameters: query,
      );

      final List data = response["data"]["data"];

      history.assignAll(
        data
            .map(
              (e) => AttendanceHistoryModel.fromJson(e),
        )
            .toList(),
      );
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}