import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import '../models/lecture_model.dart';

class LectureController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var lectures = <LectureModel>[].obs;

  @override
  void onInit() {
    getLectures();
    super.onInit();
  }

  Future<void> getLectures() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        '/student/lecture-attendance?per_page=15&page=1',
        authRequired: true,
      );

      print("📥 Lecture Response: $response");

      final data = response['data'];

      /// 🔥 الحل هنا
      if (data is Map && data['data'] is List) {
        lectures.value = (data['data'] as List)
            .map((e) => LectureModel.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();
      } else if (data is List) {
        lectures.value = data
            .map((e) => LectureModel.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();
      } else {
        lectures.value = [];
      }

      print("✅ Loaded lectures: ${lectures.length}");

    } catch (e) {
      print("❌ Lecture Error: $e");
      lectures.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}