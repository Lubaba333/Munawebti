// import 'package:get/get.dart';
// import 'package:supervisors/models/request_model.dart';
// import 'package:supervisors/models/supervisor_model.dart';
// import 'package:supervisors/services/api_service.dart';
//
//
// class RequestController extends GetxController {
//
//
//   final ApiService api = ApiService();
//
//   var requests = <RequestModel>[].obs;
//   var isLoading = false.obs;
//
//   var supervisors = <SupervisorModel>[].obs;
//   var isLoadingSupervisors = false.obs;
//
//
//   int currentUserId = 0;
//
//
//   @override
//   void onInit() {
//     print("Controller ready only");
//     fetchRequests();
//     fetchSupervisors();
//     super.onInit();
//
//   }
//
//   Future<void> fetchSupervisors() async {
//     try {
//       isLoadingSupervisors.value = true;
//
//       print("Loaded => ${supervisors.length}");
//       final response = await api.get('/supervisor/supervisors');
//
//       final List data = response['data']['data'];
//
//       supervisors.value =
//           data.map((e) => SupervisorModel.fromJson(e)).toList();
//
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoadingSupervisors.value = false;
//     }
//   }
//
//   Future<void> fetchRequests() async {
//     try {
//       isLoading.value = true;
//
//       final response = await api.get('/supervisor/requests');
//
//       final List data = response['data']['data'];
//
//       requests.value =
//           data.map((e) => RequestModel.fromJson(e)).toList();
//
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> createLeaveRequest({
//     required String date,
//     required String reason,
//     required String description,
//   }) async {
//     await api.post('/supervisor/requests', {
//       "request_type": "supervisor_leave",
//       "title": "Leave Request",
//       "description": description,
//       "metadata": {
//         "leave_date": date,
//         "reason": reason
//       }
//     });
//
//     await fetchRequests();
//   }
//
//   Future<void> createShiftExchange({
//     required int targetSupervisorId,
//     required int shiftId,
//     required String date,
//     required String fromHour,
//     required String toHour,
//     required String description,
//   }) async {
//     await api.post('/supervisor/requests', {
//       "request_type": "supervisor_shift_exchange",
//       "title": "Shift Exchange Request",
//       "description": description,
//       "metadata": {
//         "target_supervisor_id": targetSupervisorId,
//         "original_shift_id": shiftId,
//         "requested_shift_date": date,
//         "requested_from_hour": fromHour,
//         "requested_to_hour": toHour,
//       }
//     });
//     await fetchRequests();
//   }
//
//   Future<void> cancelRequest(int id) async {
//     try {
//       final response = await api.post(
//         '/supervisor/requests/$id/cancel',
//         {},
//       );
//
//       if (response['status_code'] == 200) {
//         Get.snackbar("Success", response['message']);
//         fetchRequests();
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   Future<RequestModel?> getRequestDetails(int id) async {
//
//     try {
//
//       final response =
//       await api.get('/supervisor/requests/$id');
//
//
//       if(response['status_code']==200){
//
//         return RequestModel.fromJson(
//           response['data'],
//         );
//
//       }
//
//
//     }catch(e){
//
//       Get.snackbar(
//         "Error",
//         e.toString(),
//       );
//
//     }
//
//
//     return null;
//    }
// }

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

  /// Loading الصفحة التالية
  final RxBool isLoadingMoreSupervisors = false.obs;

  /// رقم الصفحة الحالية
  final RxInt supervisorsPage = 1.obs;

  /// هل يوجد صفحات إضافية؟
  final RxBool hasMoreSupervisors = true.obs;

  /// ScrollController لقائمة المشرفين
  final ScrollController supervisorsScrollController =
  ScrollController();

  int currentUserId = 0;

  // ============================================================
  // Init
  // ============================================================

  @override
  void onInit() {
    print("Controller ready only");

    fetchRequests();

    fetchSupervisors();

    // مراقبة Scroll المشرفين
    supervisorsScrollController.addListener(() {
      if (!supervisorsScrollController.hasClients) {
        return;
      }

      final position =
          supervisorsScrollController.position;

      // عندما نقترب من نهاية القائمة
      if (position.pixels >=
          position.maxScrollExtent - 100) {
        loadMoreSupervisors();
      }
    });

    super.onInit();
  }

  // ============================================================
  // Fetch Supervisors - First Page
  // ============================================================

  Future<void> fetchSupervisors() async {
    try {
      isLoadingSupervisors.value = true;

      // إعادة pagination من البداية
      supervisorsPage.value = 1;

      hasMoreSupervisors.value = true;

      print("Loading supervisors page 1");

      final response = await api.get(
        '/supervisor/supervisors',
        queryParameters: {
          "page": 1,
          "per_page": 15,
        },
      );

      print("SUPERVISORS RESPONSE:");
      print(response);

      final data = response['data'];

      final List list = data['data'] ?? [];

      print(
        "FIRST PAGE SUPERVISORS = ${list.length}",
      );

      supervisors.assignAll(
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
                1;

        final lastPage =
            int.tryParse(
              meta['last_page']
                  ?.toString() ??
                  '',
            ) ??
                currentPage;

        supervisorsPage.value =
            currentPage;

        hasMoreSupervisors.value =
            currentPage < lastPage;
      } else {
        // Fallback
        hasMoreSupervisors.value =
            list.length == 15;
      }

      print(
        "CURRENT PAGE = ${supervisorsPage.value}",
      );

      print(
        "HAS MORE = ${hasMoreSupervisors.value}",
      );

      print(
        "TOTAL SUPERVISORS = ${supervisors.length}",
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
  // Load More Supervisors
  // ============================================================

  Future<void> loadMoreSupervisors() async {
    // منع الطلبات المتكررة
    if (isLoadingMoreSupervisors.value) {
      return;
    }

    // إذا لا يوجد صفحات إضافية
    if (!hasMoreSupervisors.value) {
      return;
    }

    try {
      isLoadingMoreSupervisors.value = true;

      final nextPage =
          supervisorsPage.value + 1;

      print(
        "Loading supervisors page $nextPage",
      );

      final response = await api.get(
        '/supervisor/supervisors',
        queryParameters: {
          "page": nextPage,
          "per_page": 15,
        },
      );

      print(
        "SUPERVISORS PAGE $nextPage RESPONSE:",
      );

      print(response);

      final data = response['data'];

      final List list =
          data['data'] ?? [];

      print(
        "NEW SUPERVISORS = ${list.length}",
      );

      // لا يوجد بيانات إضافية
      if (list.isEmpty) {
        hasMoreSupervisors.value =
        false;

        return;
      }

      final newSupervisors = list
          .map(
            (e) =>
            SupervisorModel.fromJson(e),
      )
          .toList();

      // ========================================================
      // مهم جداً
      //
      // addAll وليس assignAll
      //
      // حتى تبقى الصفحات السابقة
      // ========================================================

      supervisors.addAll(
        newSupervisors,
      );

      supervisorsPage.value =
          nextPage;

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
                nextPage;

        final lastPage =
            int.tryParse(
              meta['last_page']
                  ?.toString() ??
                  '',
            ) ??
                currentPage;

        supervisorsPage.value =
            currentPage;

        hasMoreSupervisors.value =
            currentPage < lastPage;
      } else {
        // Fallback
        hasMoreSupervisors.value =
            list.length == 15;
      }

      print(
        "TOTAL SUPERVISORS = ${supervisors.length}",
      );

      print(
        "CURRENT PAGE = ${supervisorsPage.value}",
      );

      print(
        "HAS MORE = ${hasMoreSupervisors.value}",
      );
    } catch (e) {
      print(
        "LOAD MORE SUPERVISORS ERROR: $e",
      );

      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoadingMoreSupervisors.value =
      false;
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

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void onClose() {
    supervisorsScrollController
        .dispose();

    super.onClose();
  }
}