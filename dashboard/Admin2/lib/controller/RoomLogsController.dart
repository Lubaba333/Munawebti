import 'package:get/get.dart';
import '../model/RoomLogModel.dart';
import '../services/api_service.dart';

class RoomHistoryController extends GetxController {
  final ApiService api = Get.find();

  var isLoading = false.obs;
  var history = <RoomHistoryModel>[].obs;

  Future<void> fetchHistory(int roomId) async {
    try {
      isLoading.value = true;

      final response = await api.get(
        '/admin/rooms/$roomId/history',
      );

      final responseData = response['data'];

      final List data = responseData is List
          ? responseData
          : responseData?['data'] ?? [];

      history.value =
          data.map((e) => RoomHistoryModel.fromJson(e)).toList();

    } catch (e) {
      print("ROOM HISTORY ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}