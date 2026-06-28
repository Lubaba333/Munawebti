import 'package:get/get.dart';
import 'package:studants/services/service.dart';
import '../models/lecture_model.dart';

class LectureController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var lectures = <LectureModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLectures();
  }

  Future<void> getLectures({String? day, String? date}) async {
    try {
      isLoading.value = true;

      String url = '/student/my-lectures?per_page=15&page=1';

      if (day != null && day.isNotEmpty) {
        url += '&day=$day';
      }

      if (date != null && date.isNotEmpty) {
        url += '&date=$date';
      }

      final response = await _apiService.get(
        url,
        authRequired: true,
      );

      final data = response['data'];

      final List<LectureModel> loadedLectures = [];

      if (data is List) {
        for (final dayItem in data) {
          if (dayItem is Map && dayItem['lectures'] is List) {
            final lecturesList = dayItem['lectures'] as List;

            for (final lecture in lecturesList) {
              if (lecture is Map) {
                loadedLectures.add(
                  LectureModel.fromJson(
                    Map<String, dynamic>.from(lecture),
                  ),
                );
              }
            }
          }
        }
      } else if (data is Map) {
        final list = data['data'] ?? data['lectures'] ?? data['items'];

        if (list is List) {
          for (final lecture in list) {
            if (lecture is Map) {
              loadedLectures.add(
                LectureModel.fromJson(
                  Map<String, dynamic>.from(lecture),
                ),
              );
            }
          }
        }
      }

      lectures.value = loadedLectures;

      print("✅ Loaded lectures: ${lectures.length}");
    } catch (e) {
      print("❌ My Lectures Error: $e");
      lectures.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLectures() async {
    await getLectures();
  }
}