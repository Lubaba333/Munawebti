import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Request {
  String title;
  String type;
  String status; // pending / approved / rejected / escalated
  DateTime createdAt;
  String? rejectReason;

  Request({
    required this.title,
    required this.type,
    this.status = "pending",
    required this.createdAt,
    this.rejectReason,
  });
}
class RequestController extends GetxController {
  var requests = <Request>[].obs;
  var selectedFilter = "all".obs;

  /// 🔥 NEW
  var sortType = "newest".obs; // newest / oldest

  @override
  void onInit() {
    super.onInit();

    requests.addAll([
      Request(
        title: "Building Permit",
        type: "Construction",
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Request(
        title: "Maintenance Request",
        type: "Service",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Request(
        title: "Maintenance Request",
        type: "Service",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),Request(
        title: "Maintenance Request",
        type: "Service",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),Request(
        title: "Maintenance Request",
        type: "Service",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),


    ]);

    _startAutoEscalation();
  }

  void approve(int index) {
    requests[index].status = "approved";
    requests.refresh();
  }

  void reject(int index, String reason) {
    requests[index].status = "rejected";
    requests[index].rejectReason = reason;
    requests.refresh();
  }

  void _startAutoEscalation() {
    ever(requests, (_) {
      for (var r in requests) {
        if (r.status == "pending" &&
            DateTime.now().difference(r.createdAt).inHours > 24) {
          r.status = "escalated";
        }
      }
      requests.refresh();
    });
  }

  /// 🔥 FILTER + SORT
  List<Request> get filteredRequests {
    List<Request> list;

    if (selectedFilter.value == "all") {
      list = requests.toList();
    } else {
      list = requests
          .where((r) => r.status == selectedFilter.value)
          .toList();
    }

    /// 🔥 SORTING
    if (sortType.value == "newest") {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return list;
  }
}