import 'package:get/get.dart';
import '../model/CurrentRoomModel.dart';
import '../services/api_service.dart';



class CurrentRoomController extends GetxController {
  final ApiService api = Get.find();

  var isLoading = false.obs;
  var currentRoom = Rxn<CurrentRoomModel>();

  Future<void> fetchCurrentRoom(int studentId) async {
    try {
      isLoading.value = true;

      final response = await api.get(
        '/admin/students/$studentId/current-room',
      );

      final data = response['data'];

      if (data != null) {
        currentRoom.value = CurrentRoomModel.fromJson(data);
      } else {
        currentRoom.value = null;
      }
    } catch (e) {
      print("CURRENT ROOM ERROR: $e");
      currentRoom.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}