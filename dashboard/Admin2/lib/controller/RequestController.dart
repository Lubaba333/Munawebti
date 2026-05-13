import 'package:get/get.dart';
import '../model/RequestModel.dart';
import '../services/api_service.dart';

class RequestController extends GetxController {
  final ApiService api = ApiService();

  var requests = <RequestModel>[].obs;

  var selectedFilter = "all".obs;
  var sortType = "newest".obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  /// 📡 GET REQUESTS
  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;

      final response = await api.get(
        "/admin/requests",
        queryParameters: {
          "per_page": 50,
          "page": 1,
        },
      );

      print(response);

      List data = response['data']['data'];

      requests.value =
          data.map((e) => RequestModel.fromJson(e)).toList();

    } catch (e) {
      print("GET ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ APPROVE (حسب الكوليكشن)
  Future<void> approveRequest(
      int id, {
        String reason = "Approved",
        Map<String, dynamic>? metadata,
      }) async {
    try {
      await api.post(
        "/admin/requests/$id/approve",
        {
          "reason": reason,
          if (metadata != null) "metadata": metadata,
        },
      );

      _updateStatus(id, "approved");
    } catch (e) {
      print("APPROVE ERROR: $e");
    }
  }

  /// ❌ REJECT
  Future<void> rejectRequest(int id, String reason) async {
    try {
      await api.post(
        "/admin/requests/$id/reject",
        {
          "reason": reason,
        },
      );

      _updateStatus(id, "rejected");
    } catch (e) {
      print("REJECT ERROR: $e");
    }
  }

  /// 🔄 LOCAL UPDATE
  void _updateStatus(int id, String status) {
    int index = requests.indexWhere((e) => e.id == id);

    if (index != -1) {
      requests[index] = RequestModel(
        id: requests[index].id,
        type: requests[index].type,
        status: status,
        requesterType: requests[index].requesterType,
        requesterId: requests[index].requesterId,
        createdAt: requests[index].createdAt,
        metadata: requests[index].metadata,
      );

      requests.refresh();
    }
  }

  /// 📊 FILTER + SORT (نفس التصميم عندك بدون تغيير)
  List<RequestModel> get filteredRequests {
    List<RequestModel> list = requests.toList();

    if (selectedFilter.value != "all") {
      list = list.where((e) => e.status == selectedFilter.value).toList();
    }

    if (sortType.value == "newest") {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return list;
  }
}