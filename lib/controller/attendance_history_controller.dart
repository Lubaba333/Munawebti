import 'package:get/get.dart';

import '../models/attendance_history_model.dart';
import '../services/api_service.dart';

class AttendanceHistoryController extends GetxController {
  final ApiService apiService;

  final String? shiftType;

  AttendanceHistoryController(
      this.apiService, {
        this.shiftType,
      });

  // ============================================================
  // STATE
  // ============================================================

  final RxList<AttendanceHistoryModel> history =
      <AttendanceHistoryModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  // ============================================================
  // PAGINATION
  // ============================================================

  final RxInt currentPage = 1.obs;

  final RxInt lastPage = 1.obs;

  final RxInt total = 0.obs;

  final RxBool hasMore = true.obs;

  // ============================================================
  // FILTERS
  // ============================================================

  /// lecture / housing
  final RxString selectedType = ''.obs;

  /// present / absent
  final RxString selectedStatus = ''.obs;

  /// yyyy-MM-dd
  final RxString dateFrom = ''.obs;

  /// yyyy-MM-dd
  final RxString dateTo = ''.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    if (shiftType != null && shiftType!.trim().isNotEmpty) {
      selectedType.value = shiftType!.trim();
    }

    loadHistory();
  }

  // ============================================================
  // LOAD HISTORY
  // ============================================================

  Future<void> loadHistory({
    int page = 1,
    bool refresh = false,
  }) async {
    if (isLoading.value) {
      return;
    }

    if (!refresh && !hasMore.value && page != 1) {
      return;
    }

    try {
      if (refresh) {
        history.clear();

        currentPage.value = 1;
        lastPage.value = 1;
        total.value = 0;
        hasMore.value = true;

        page = 1;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // ========================================================
      // QUERY
      // ========================================================

      final Map<String, dynamic> query = {
        'page': page,
        'per_page': 15,
      };

      // Shift type
      final String type = selectedType.value.trim();

      if (type.isNotEmpty) {
        query['shift_type'] = type;
      }

      // Status
      final String status = selectedStatus.value.trim();

      if (status.isNotEmpty) {
        query['status'] = status;
      }

      // Date from
      final String from = dateFrom.value.trim();

      if (from.isNotEmpty) {
        query['date_from'] = from;
      }

      // Date to
      final String to = dateTo.value.trim();

      if (to.isNotEmpty) {
        query['date_to'] = to;
      }

      // ========================================================
      // API
      // ========================================================

      final response = await apiService.get(
        '/supervisor/attendance/history',
        queryParameters: query,
      );

      // ========================================================
      // RESPONSE VALIDATION
      // ========================================================

      if (response is! Map<String, dynamic>) {
        throw Exception(
          'Invalid server response',
        );
      }

      final dynamic responseData = response['data'];

      if (responseData is! Map<String, dynamic>) {
        throw Exception(
          'Invalid attendance history data',
        );
      }

      // ========================================================
      // LIST
      // ========================================================

      final dynamic rawList = responseData['data'];

      if (rawList is! List) {
        throw Exception(
          'Invalid attendance history list',
        );
      }

      final List<AttendanceHistoryModel> newData = [];

      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          newData.add(
            AttendanceHistoryModel.fromJson(item),
          );
        }
      }

      // ========================================================
      // UPDATE LIST
      // ========================================================

      if (page == 1) {
        history.assignAll(newData);
      } else {
        history.addAll(newData);
      }

      // ========================================================
      // PAGINATION
      // ========================================================

      currentPage.value = _toInt(
        responseData['current_page'],
        fallback: page,
      );

      lastPage.value = _toInt(
        responseData['last_page'],
        fallback: currentPage.value,
      );

      total.value = _toInt(
        responseData['total'],
        fallback: history.length,
      );

      hasMore.value =
          currentPage.value < lastPage.value;
    } catch (e) {
      errorMessage.value = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHANGE TYPE
  // ============================================================

  Future<void> changeType(String type) async {
    selectedType.value = type.trim();

    await loadHistory(
      refresh: true,
    );
  }

  // ============================================================
  // CHANGE STATUS
  // ============================================================

  Future<void> changeStatus(String status) async {
    selectedStatus.value = status.trim();

    await loadHistory(
      refresh: true,
    );
  }

  // ============================================================
  // CHANGE DATE
  // ============================================================

  Future<void> changeDate({
    String? from,
    String? to,
  }) async {
    dateFrom.value = from?.trim() ?? '';
    dateTo.value = to?.trim() ?? '';

    await loadHistory(
      refresh: true,
    );
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  Future<void> clearFilters() async {
    selectedType.value = '';
    selectedStatus.value = '';
    dateFrom.value = '';
    dateTo.value = '';

    await loadHistory(
      refresh: true,
    );
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  Future<void> loadNextPage() async {
    if (isLoading.value) {
      return;
    }

    if (!hasMore.value) {
      return;
    }

    await loadHistory(
      page: currentPage.value + 1,
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshHistory() async {
    await loadHistory(
      refresh: true,
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  int _toInt(
      dynamic value, {
        int fallback = 0,
      }) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  // ============================================================
  // GETTERS
  // ============================================================

  int get presentCount {
    return history
        .where(
          (item) => item.status == 'present',
    )
        .length;
  }

  int get absentCount {
    return history
        .where(
          (item) => item.status == 'absent',
    )
        .length;
  }

  bool get hasData {
    return history.isNotEmpty;
  }

  bool get hasError {
    return errorMessage.value.isNotEmpty;
  }
}