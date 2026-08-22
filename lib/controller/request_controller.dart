import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/request_model.dart';
import 'package:supervisors/models/supervisor_model.dart';
import 'package:supervisors/services/api_service.dart';

class RequestController extends GetxController {
  final ApiService api = ApiService();

  // ============================================================
  // Requests
  // ============================================================

  final RxList<RequestModel> requests =
      <RequestModel>[].obs;

  final RxBool isLoading = false.obs;

  // ============================================================
  // Supervisors
  // ============================================================

  final RxList<SupervisorModel> supervisors =
      <SupervisorModel>[].obs;

  final RxBool isLoadingSupervisors = false.obs;

  int currentUserId = 0;

  // ============================================================
  // Init
  // ============================================================

  @override
  void onInit() {
    print("Controller ready only");

    fetchRequests();

    fetchSupervisors();

    super.onInit();
  }

  // ============================================================
  // Fetch Supervisors - كل الصفحات دفعة وحدة
  // ============================================================
  //
  // ملاحظة مهمة:
  // الـ API عندنا ثابتة على 15 عنصر بالصفحة بغض النظر
  // عن قيمة per_page المرسلة، فبدل ما نعتمد على تكبير
  // per_page، منعمل لوب يمشي على كل الصفحات (page 1, 2, 3...)
  // لحد ما نوصل لآخر صفحة (last_page) ونجمعهم كلهم بقائمة وحدة.
  // ============================================================

  Future<void> fetchSupervisors() async {
    try {
      isLoadingSupervisors.value = true;

      List<SupervisorModel> allSupervisors = [];

      int page = 1;
      bool hasMore = true;

      while (hasMore) {
        print("Loading supervisors page $page");

        final response = await api.get(
          '/supervisor/supervisors',
          queryParameters: {
            "page": page,
            "per_page": 15,
          },
        );

        final data = response['data'];

        final List list = data['data'] ?? [];

        print("Page $page returned ${list.length} supervisors");

        allSupervisors.addAll(
          list
              .map(
                (e) => SupervisorModel.fromJson(e),
          )
              .toList(),
        );

        // ========================================================
        // Pagination Meta
        // ========================================================

        final meta = data['meta'];

        if (meta != null) {
          final currentPage =
              int.tryParse(
                meta['current_page']
                    ?.toString() ??
                    '',
              ) ??
                  page;

          final lastPage =
              int.tryParse(
                meta['last_page']
                    ?.toString() ??
                    '',
              ) ??
                  currentPage;

          print(
            "current_page = $currentPage , last_page = $lastPage",
          );

          hasMore = currentPage < lastPage;

          page = currentPage + 1;
        } else {
          // Fallback: لو ما في meta، نوقف لما تجي صفحة
          // فيها أقل من 15 عنصر (يعني وصلنا آخر صفحة)
          hasMore = list.length == 15;

          page++;
        }

        // ========================================================
        // حماية من اللوب اللانهائي
        // (بحال صار خلل بحساب hasMore لأي سبب)
        // ========================================================

        if (page > 50) {
          print(
            "Stopped pagination after 50 pages - safety limit",
          );

          break;
        }
      }

      // ==============================================================
      // إزالة أي تكرار محتمل حسب id قبل التخزين
      // (مهم جداً: القيم المكررة بتكسر DropdownButtonFormField)
      // ==============================================================

      final Map<int, SupervisorModel> uniqueMap = {
        for (final sup in allSupervisors) sup.id: sup,
      };

      supervisors.assignAll(
        uniqueMap.values.toList(),
      );

      print(
        "TOTAL UNIQUE SUPERVISORS = ${supervisors.length}",
      );
    } catch (e) {
      print(
        "FETCH SUPERVISORS ERROR: $e",
      );

      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoadingSupervisors.value = false;
    }
  }

  // ============================================================
  // Fetch Requests
  // ============================================================

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;

      final response =
      await api.get(
        '/supervisor/requests',
      );

      final List data =
      response['data']['data'];

      requests.assignAll(
        data
            .map(
              (e) =>
              RequestModel.fromJson(e),
        )
            .toList(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Create Leave Request
  // ============================================================

  Future<void> createLeaveRequest({
    required String date,
    required String reason,
    required String description,
  }) async {
    await api.post(
      '/supervisor/requests',
      {
        "request_type":
        "supervisor_leave",
        "title":
        "Leave Request",
        "description":
        description,
        "metadata": {
          "leave_date": date,
          "reason": reason,
        },
      },
    );

    await fetchRequests();
  }

  // ============================================================
  // Create Shift Exchange
  // ============================================================

  Future<void> createShiftExchange({
    required int targetSupervisorId,
    required int shiftId,
    required String date,
    required String fromHour,
    required String toHour,
    required String description,
  }) async {
    await api.post(
      '/supervisor/requests',
      {
        "request_type":
        "supervisor_shift_exchange",
        "title":
        "Shift Exchange Request",
        "description":
        description,
        "metadata": {
          "target_supervisor_id":
          targetSupervisorId,
          "original_shift_id":
          shiftId,
          "requested_shift_date":
          date,
          "requested_from_hour":
          fromHour,
          "requested_to_hour":
          toHour,
        },
      },
    );

    await fetchRequests();
  }

  // ============================================================
  // Cancel Request
  // ============================================================

  Future<void> cancelRequest(int id) async {
    try {
      final response =
      await api.post(
        '/supervisor/requests/$id/cancel',
        {},
      );

      if (response['status_code'] ==
          200) {
        Get.snackbar(
          "Success",
          response['message'],
        );

        await fetchRequests();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  // ============================================================
  // Request Details
  // ============================================================

  Future<RequestModel?> getRequestDetails(
      int id,
      ) async {
    try {
      final response =
      await api.get(
        '/supervisor/requests/$id',
      );

      if (response['status_code'] ==
          200) {
        return RequestModel.fromJson(
          response['data'],
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }

    return null;
  }
}
