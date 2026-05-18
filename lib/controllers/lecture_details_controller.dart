import 'package:get/get.dart';
import 'package:studants/services/service.dart';

class LectureDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var lecture = {}.obs;

  final int lectureId;

  LectureDetailsController(this.lectureId);

  @override
  void onInit() {
    getLectureDetails();
    super.onInit();
  }

  Future<void> getLectureDetails() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/lecture-attendance/$lectureId',
        authRequired: true,
      );

      print("📥 Lecture Details: $response");

      if (response['data'] != null) {
        lecture.value = Map<String, dynamic>.from(response['data']);
      } else {
        lecture.value = {};
      }

    } catch (e) {
      print("❌ Details Error: $e");
      lecture.value = {};
    } finally {
      isLoading.value = false;
    }
  }
}