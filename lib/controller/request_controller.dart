import 'package:get/get.dart';
import 'package:supervisors/models/request_model.dart';
import 'package:supervisors/models/supervisor_model.dart';
import 'package:supervisors/services/api_service.dart';


class RequestController extends GetxController {

  // final RequestController requestController = Get.find<RequestController>();
  final ApiService api = ApiService();

  var requests = <RequestModel>[].obs;
  var isLoading = false.obs;

  var supervisors = <SupervisorModel>[].obs;
  var isLoadingSupervisors = false.obs;


  int currentUserId = 0;


  @override
  void onInit() {
    print("Controller ready only");
    fetchRequests();
    fetchSupervisors();
    super.onInit();

  }

  Future<void> fetchSupervisors() async {
    try {
      isLoadingSupervisors.value = true;

      print("Loaded => ${supervisors.length}");
      final response = await api.get('/supervisor/supervisors');

      final List data = response['data']['data'];

      supervisors.value =
          data.map((e) => SupervisorModel.fromJson(e)).toList();

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingSupervisors.value = false;
    }
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;

      final response = await api.get('/supervisor/requests');

      final List data = response['data']['data'];

      requests.value =
          data.map((e) => RequestModel.fromJson(e)).toList();

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLeaveRequest({
    required String date,
    required String reason,
    required String description,
  }) async {
    await api.post('/supervisor/requests', {
      "request_type": "supervisor_leave",
      "title": "Leave Request",
      "description": description,
      "metadata": {
        "leave_date": date,
        "reason": reason
      }
    });

    await fetchRequests();
  }

  Future<void> createShiftExchange({
    required int targetSupervisorId,
    required int shiftId,
    required String date,
    required String fromHour,
    required String toHour,
    required String description,
  }) async {
    await api.post('/supervisor/requests', {
      "request_type": "supervisor_shift_exchange",
      "title": "Shift Exchange Request",
      "description": description,
      "metadata": {
        "target_supervisor_id": targetSupervisorId,
        "original_shift_id": shiftId,
        "requested_shift_date": date,
        "requested_from_hour": fromHour,
        "requested_to_hour": toHour,
      }
    });
    await fetchRequests();
  }

  Future<void> cancelRequest(int id) async {
    try {
      final response = await api.post(
        '/supervisor/requests/$id/cancel',
        {},
      );

      if (response['status_code'] == 200) {
        Get.snackbar("Success", response['message']);
        fetchRequests();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<RequestModel?> getRequestDetails(int id) async {

    try {

      final response =
      await api.get('/supervisor/requests/$id');


      if(response['status_code']==200){

        return RequestModel.fromJson(
          response['data'],
        );

      }


    }catch(e){

      Get.snackbar(
        "Error",
        e.toString(),
      );

    }


    return null;
   }
}