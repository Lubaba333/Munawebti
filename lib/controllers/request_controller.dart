import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/models/request_model.dart';
import 'package:studants/services/service.dart';
import 'package:studants/views/my_requests_view.dart';
import 'package:studants/views/request_details_view.dart';

class RequestController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var isLoadingCurrentRoom = false.obs;
  var isLoadingRoomStudents = false.obs;
var isLoadingRooms = false.obs;
  var requests = <dynamic>[].obs;
  var rooms = <dynamic>[].obs;
  var roomStudents = <dynamic>[].obs;
var initialLoading = true.obs;
  var currentRoom = Rxn<Map<String, dynamic>>();
  var currentStudentId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    getRooms();
    getCurrentStudentRoom();
  }

  List<dynamic> _extractList(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is List) return data;

    if (data is Map) {
      if (data['data'] is List) return data['data'];
      if (data['items'] is List) return data['items'];
      if (data['requests'] is List) return data['requests'];
      if (data['rooms'] is List) return data['rooms'];
      if (data['students'] is List) return data['students'];
    }

    return [];
  }

  Future<void> _handleRequestSuccess(String message) async {
  Get.snackbar(
    "تم بنجاح",
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  await getMyRequests();

  Get.off(() => const MyRequestsView());
}

  Future<void> getCurrentStudentRoom() async {
    try {
      isLoadingCurrentRoom.value = true;

      final response = await _apiService.get(
        '/auth/student/me',
        authRequired: true,
      );

      print("👤 Student Me Response: $response");

      final student = response['data']?['student'];

      if (student == null) {
        currentStudentId.value = null;
        currentRoom.value = null;
        return;
      }

      if (student['id'] != null) {
        currentStudentId.value = int.tryParse(student['id'].toString());
      }

      final room = student['current_room'];

      if (room != null && room is Map) {
        currentRoom.value = Map<String, dynamic>.from(room);
        print("✅ Current Room Loaded: ${currentRoom.value}");
      } else {
        currentRoom.value = null;
        print("⚠️ current_room is null. is_resident = ${student['is_resident']}");
      }
    } catch (e) {
      print("❌ Current Room Error: $e");
      currentStudentId.value = null;
      currentRoom.value = null;
    } finally {
      isLoadingCurrentRoom.value = false;
    }
  }

  Future<void> getRooms({bool availableOnly = false}) async {
  try {
    isLoadingRooms.value = true;

    final response = await _apiService.get(
      '/student/rooms',
      queryParameters: {
        'per_page': 50,
        'page': 1,
        if (availableOnly) 'available_only': true,
      },
      authRequired: true,
    );

    rooms.value = _extractList(response);

    print("✅ Rooms loaded: ${rooms.length}");
  } catch (e) {
    print("❌ Rooms Error: $e");
    rooms.value = [];
  } finally {
    isLoadingRooms.value = false;
  }
}

  Future<void> getRoomStudents(int roomId) async {
    try {
      isLoadingRoomStudents.value = true;

      final response = await _apiService.get(
        '/student/rooms/$roomId/students',
        queryParameters: {
          'per_page': 50,
          'page': 1,
        },
        authRequired: true,
      );

      roomStudents.value = _extractList(response);
      print("✅ Room Students loaded: ${roomStudents.length}");
    } catch (e) {
      print("❌ Room Students Error: $e");
      roomStudents.value = [];
    } finally {
      isLoadingRoomStudents.value = false;
    }
  }

  Future<void> getMyRequests() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/requests',
        queryParameters: {
          'per_page': 15,
          'page': 1,
        },
        authRequired: true,
      );

      requests.value = _extractList(response);
      print("✅ Requests loaded: ${requests.length}");
    } catch (e) {
      print("❌ Get Requests Error: $e");
      requests.value = [];
    } finally {
  isLoading.value = false;
  initialLoading.value = false;
}
  }

  Future<void> createExitRequest(ExitPermissionRequest request) async {
    try {
      isSubmitting.value = true;

      await _apiService.post(
        '/student/requests',
        request.toJson(),
        authRequired: true,
      );

      await _handleRequestSuccess("تم تسجيل طلب سماح الخروج بنجاح");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> createSpecificRoomRequest({
    required int requestedRoomId,
    required String reason,
  }) async {
    final current = currentRoom.value;

    if (current == null || current['id'] == null) {
      Get.snackbar("تنبيه", "لم يتم تحميل غرفتك الحالية بعد");
      return;
    }

    final int currentRoomId = int.parse(current['id'].toString());

    if (currentRoomId == requestedRoomId) {
      Get.snackbar("تنبيه", "لا يمكن اختيار نفس غرفتك الحالية");
      return;
    }

    if (reason.trim().isEmpty) {
      Get.snackbar("تنبيه", "اكتبي سبب طلب تبديل الغرفة");
      return;
    }

    try {
      isSubmitting.value = true;

      final body = {
        "request_type": "student_room_change",
        "room_change_type": "specific_room",
        "title": "Specific Room Change Request",
        "description": reason.trim(),
        "metadata": {
          "current_room_id": currentRoomId,
          "requested_room_id": requestedRoomId,
          "reason": reason.trim(),
        }
      };

      print("📤 Specific Room Request: $body");

      await _apiService.post(
        '/student/requests',
        body,
        authRequired: true,
      );

      await _handleRequestSuccess("تم إرسال طلب تبديل الغرفة بنجاح");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> createAnyAvailableRoomRequest({
    required String reason,
  }) async {
    final current = currentRoom.value;

    if (current == null || current['id'] == null) {
      Get.snackbar("تنبيه", "لم يتم تحميل غرفتك الحالية بعد");
      return;
    }

    final int currentRoomId = int.parse(current['id'].toString());

    if (reason.trim().isEmpty) {
      Get.snackbar("تنبيه", "اكتبي سبب طلب النقل");
      return;
    }

    try {
      isSubmitting.value = true;

      final body = {
        "request_type": "student_room_change",
        "room_change_type": "any_available",
        "title": "Room Change Request - Any Available Room",
        "description": reason.trim(),
        "metadata": {
          "current_room_id": currentRoomId,
          "reason": reason.trim(),
        }
      };

      print("📤 Any Available Room Request: $body");

      await _apiService.post(
        '/student/requests',
        body,
        authRequired: true,
      );

      await _handleRequestSuccess("تم تسجيل طلب النقل بنجاح");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception:', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> createExchangeRoomRequest({
    required int targetRoomId,
    required int targetStudentId,
    required String reason,
  }) async {
    final current = currentRoom.value;

    if (current == null || current['id'] == null) {
      Get.snackbar("تنبيه", "لم يتم تحميل غرفتك الحالية بعد");
      return;
    }

    final int currentRoomId = int.parse(current['id'].toString());

    if (currentRoomId == targetRoomId) {
      Get.snackbar("تنبيه", "لا يمكن التبديل مع نفس غرفتك الحالية");
      return;
    }

    if (reason.trim().isEmpty) {
      Get.snackbar("تنبيه", "اكتبي سبب طلب التبديل");
      return;
    }

    try {
      isSubmitting.value = true;

      final body = {
        "request_type": "student_room_change",
        "room_change_type": "exchange",
        "target_student_id": targetStudentId,
        "title": "Room Exchange Request",
        "description": reason.trim(),
        "metadata": {
          "current_room_id": currentRoomId,
          "target_room_id": targetRoomId,
          "reason": reason.trim(),
        }
      };

      print("📤 Exchange Room Request: $body");

      await _apiService.post(
        '/student/requests',
        body,
        authRequired: true,
      );

      await _handleRequestSuccess("تم تسجيل طلب التبديل مع طالبة بنجاح");
    } catch (e) {
     final error = e.toString().replaceAll('Exception:', '').trim();

String message = error;

if (error.contains('already a pending exchange request')) {
  message = 'يوجد طلب تبديل سابق قيد الانتظار مع هذه الطالبة';
}

Get.snackbar(
  "تعذر إرسال الطلب",
  message,
  backgroundColor: Colors.orange,
  colorText: Colors.white,
  snackPosition: SnackPosition.BOTTOM,
);
    } finally {
      isSubmitting.value = false;
    }
  }

Future<void> approveExchangeRequest(int requestId) async {
  try {
    isSubmitting.value = true;

    await _apiService.post(
      '/student/requests/$requestId/approve-exchange',
      {},
      authRequired: true,
    );

    final index = requests.indexWhere(
      (r) => r['id'].toString() == requestId.toString(),
    );

    if (index != -1) {
      requests[index]['target_student_approved_at'] =
          DateTime.now().toIso8601String();
      requests[index]['target_student_rejection_reason'] = null;
      requests.refresh();
    }

    Get.snackbar(
      "تم بنجاح",
      "تم قبول الطلب وتحويله للإدارة",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    await getMyRequests();
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString().replaceAll('Exception:', ''),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isSubmitting.value = false;
  }
}

Future<void> rejectExchangeRequest({
  required int requestId,
  required String reason,
}) async {
  try {
    isSubmitting.value = true;

    await _apiService.post(
      '/student/requests/$requestId/reject-exchange',
      {
        "reason": reason.trim().isEmpty
            ? "Rejected by student"
            : reason.trim(),
      },
      authRequired: true,
    );

    final index = requests.indexWhere(
      (r) => r['id'].toString() == requestId.toString(),
    );

    if (index != -1) {
      requests[index]['target_student_rejection_reason'] =
          reason.trim().isEmpty
              ? "Rejected by student"
              : reason.trim();

      requests[index]['target_student_approved_at'] = null;

      requests.refresh();
    }

    Get.snackbar(
      "تم بنجاح",
      "تم رفض الطلب",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    await getMyRequests();
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString().replaceAll('Exception:', ''),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isSubmitting.value = false;
  }
}

Future<void> cancelRequest(int requestId) async {
  try {
    isLoading.value = true;

    await _apiService.post(
      '/student/requests/$requestId/cancel',
      {},
      authRequired: true,
    );

    Get.snackbar(
      "تم بنجاح",
      "تم إلغاء الطلب بنجاح",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    await getMyRequests();
  } catch (e) {
    Get.snackbar(
      "تعذر إلغاء الطلب",
      e.toString().replaceAll('Exception:', ''),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
  }
}
  var selectedRequest = Rxn<Map<String, dynamic>>();
var isLoadingRequestDetails = false.obs;

Future<void> showRequestDetails(int requestId) async {
  try {
    isLoadingRequestDetails.value = true;

    final response = await _apiService.get(
      '/student/requests/$requestId',
      authRequired: true,
    );

    print("📌 Request Details Response: $response");

    dynamic data = response['data'];

    if (data is Map && data['request'] is Map) {
      data = data['request'];
    }

    if (data is Map) {
      selectedRequest.value = Map<String, dynamic>.from(data);
      Get.to(() => const RequestDetailsView());
    } else {
      Get.snackbar("تنبيه", "لم يتم تحميل تفاصيل الطلب");
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString().replaceAll('Exception:', ''),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoadingRequestDetails.value = false;
  }
}
}