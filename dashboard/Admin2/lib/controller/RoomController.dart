import 'package:get/get.dart';
import '../services/api_service.dart';
import '../model/RoomModel.dart';

class RoomController extends GetxController {
  final ApiService api = Get.find();

  var rooms = <RoomModel>[].obs;
  var isLoading = false.obs;

  /// 🔵 GET ROOMS
  Future<void> fetchRooms(int unitId) async {
    try {
      isLoading.value = true;

      final response = await api.get(
        '/admin/rooms?dormitory_unit_id=$unitId',
      );

      final List data = response['data']['data'] ?? [];

      rooms.value = data.map((e) => RoomModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل الغرف");
      print("FETCH ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🟢 ADD ROOM
  Future<void> addRoom({
    required int unitId,
    required String roomNumber,
    required int capacity,
  }) async {
    try {
      await api.post('/admin/rooms', {
        "room_number": roomNumber,
        "dormitory_unit_id": unitId,
        "capacity": capacity,
      });

      fetchRooms(unitId);
    } catch (e) {
      Get.snackbar("خطأ", "فشل إضافة الغرفة");
      print("ADD ERROR: $e");
    }
  }

  /// 🟡 UPDATE ROOM
  Future<void> updateRoom({
    required int roomId,
    required int unitId,
    required int capacity,
  }) async {
    try {
      await api.put('/admin/rooms/$roomId', {
        "capacity": capacity,
      });

      fetchRooms(unitId);
    } catch (e) {
      Get.snackbar("خطأ", "فشل تعديل الغرفة");
      print("UPDATE ERROR: $e");
    }
  }

  /// 🔴 DELETE ROOM
  Future<void> deleteRoom(int roomId, int unitId) async {
    try {
      await api.delete('/admin/rooms/$roomId');

      fetchRooms(unitId);
    } catch (e) {
      Get.snackbar("خطأ", "فشل حذف الغرفة");
      print("DELETE ERROR: $e");
    }
  }
}