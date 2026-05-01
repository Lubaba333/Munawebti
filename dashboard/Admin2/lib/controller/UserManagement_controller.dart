import 'package:get/get.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';

class UserManagementController extends GetxController {

  final ApiService _apiService = Get.find<ApiService>();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var filter = "Students".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      String endpoint = filter.value == "Supervisors" ? '/admin/supervisors' : '/admin/students';

      final response = await _apiService.get(endpoint);


      if (response['data'] != null && response['data']['data'] != null) {
        List data = response['data']['data'];


        users.assignAll(data.map((e) => UserModel.fromJson(e, filter.value == "Supervisors" ? "Supervisor" : "Student")).toList());
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      String endpoint = user.role == "Student" ? '/admin/students' : '/admin/supervisors';


      final response = await _apiService.post(endpoint, user.toJson());

      if (response != null) {
        fetchUsers();
        Get.back();
        Get.snackbar("success", "Added${user.role == "Student" ? 'student' : 'supervisors'} successfully");
      }
    } catch (e) {
      Get.snackbar("Erorr", "The addition process failed: $e");
    }
  }


  Future<void> updateUser(UserModel user) async {
    try {
      if (user.id == null) return;

      String endpoint = user.role == "Student"
          ? '/admin/students/${user.id}'
          : '/admin/supervisors/${user.id}';


      final response = await _apiService.put(endpoint, user.toJson());

      if (response != null) {
        fetchUsers();
        Get.back();
        Get.snackbar("success", "The data has been updated successfully");
      }
    } catch (e) {
      Get.snackbar("Erorr", "The modification process failed: $e");
    }
  }


  Future<void> toggleBlock(UserModel user) async {
    try {
      String type = user.role == "Student" ? 'students' : 'supervisors';
      String action = user.isBlocked ? 'unblock' : 'block';

      final response = await _apiService.post('/admin/$type/${user.id}/$action', {});

      if (response != null) {
        fetchUsers();
        Get.snackbar("Ok", "The ban status has been successfully changed.");
      }
    } catch (e) {
      Get.snackbar("Erorr", "An error occurred while changing the block status");
    }
  }

  // 5. حذف مستخدم (Delete)
  Future<void> deleteUser(int id) async {
    try {
      String type = filter.value == "Supervisors" ? 'supervisors' : 'students';
      final response = await _apiService.delete('/admin/$type/$id');

      if (response != null) {
        users.removeWhere((u) => u.id == id);
        Get.snackbar("Delet", "The user has been deleted successfully");
      }
    } catch (e) {
      Get.snackbar("Eroor", "The deletion process could not be completed.");
    }
  }


  void changeFilter(String newFilter) {
    filter.value = newFilter;
    fetchUsers();
  }
}