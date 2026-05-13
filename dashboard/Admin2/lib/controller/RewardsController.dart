import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/RewardModel.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';

class RewardsController extends GetxController {
  final UserModel user;

  RewardsController({
    required this.user,
  });

  final ApiService apiService = ApiService();

  /// =========================
  /// STATE
  /// =========================
  RxBool isLoading = false.obs;
  RxList<RewardModel> rewards = <RewardModel>[].obs;

  /// target type (student / supervisor)
  RxString targetType = "student".obs;

  /// reward type
  RxString rewardType = 'excellence'.obs;

  /// =========================
  /// CONTROLLERS
  /// =========================
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  TextEditingController rewardDateController = TextEditingController();

  /// =========================
  /// target id
  /// =========================
  int get targetId => user.id!;

  @override
  void onInit() {
    super.onInit();
    getRewards();
  }

  /// =========================================================
  /// GET REWARDS
  /// =========================================================
  Future<void> getRewards() async {
    try {
      isLoading.value = true;

      print("📥 GET REWARDS FOR USER: ${user.id}");

      final response = await apiService.get(
        '/admin/rewards',
        queryParameters: {
          'per_page': 15,
          'page': 1,

          /// 🔥 أهم سطر
          'student_id': user.role == "Student" ? user.id : null,
          'supervisor_id': user.role == "Supervisor" ? user.id : null,
        },
      );

      print("📥 RESPONSE:");
      print(response);

      final List data = response['data']['data'] ?? [];

      rewards.value =
          data.map((e) => RewardModel.fromJson(e)).toList();

      print("✅ FILTERED REWARDS: ${rewards.length}");

    } catch (e) {
      print("❌ GET REWARDS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateReward(int id) async {
    try {
      isLoading.value = true;

      final body = {
        "target_type": targetType.value,
        "reward_type": rewardType.value,
        "title": titleController.text,
        "description": descriptionController.text,
        "reward_date": rewardDateController.text,
        "points": int.parse(pointsController.text),
      };

      print("📤 UPDATE REWARD ID: $id");
      print("📤 BODY: $body");

      await apiService.post(
        '/admin/rewards/$id',
        {
          ...body,
          "_method": "PUT",
        },
      );

      Get.snackbar(
        "Success",
        "Reward updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
      getRewards();

    } catch (e) {
      print("❌ UPDATE REWARD ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// =========================================================
  /// CREATE REWARD
  /// =========================================================
  Future<void> createReward() async {
    try {
      isLoading.value = true;

      final body = {
        "target_type": targetType.value, // 🔥 FIX مهم
        "target_id": targetId,
        "reward_type": rewardType.value,
        "title": titleController.text,
        "description": descriptionController.text,
        "reward_date": rewardDateController.text,
        "points": int.tryParse(pointsController.text) ?? 0,
      };

      /// 🔥 PRINT REQUEST
      print("🚀 CREATE REWARD REQUEST:");
      print(body);

      final response = await apiService.post(
        '/admin/rewards',
        body,
      );

      /// 🔥 PRINT RESPONSE
      print("✅ CREATE REWARD RESPONSE:");
      print(response);

      Get.snackbar(
        "Success",
        "Reward created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
      await getRewards();

    } catch (e, stack) {
      /// 🔥 PRINT ERROR FULL
      print("❌ CREATE REWARD ERROR:");
      print(e);
      print(stack);

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } finally {
      isLoading.value = false;
    }
  }

  /// =========================================================
  /// DELETE REWARD
  /// =========================================================
  Future<void> deleteReward(int id) async {
    try {
      isLoading.value = true;

      print("🗑 DELETE REWARD ID: $id");

      final response = await apiService.delete(
        '/admin/rewards/$id',
      );

      print("🗑 DELETE RESPONSE:");
      print(response);

      rewards.removeWhere((e) => e.id == id);

      Get.snackbar(
        "Success",
        "Reward deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e, stack) {
      print("❌ DELETE ERROR:");
      print(e);
      print(stack);

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } finally {
      isLoading.value = false;
    }
  }

  /// =========================================================
  /// CLEAR FIELDS
  /// =========================================================
  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    pointsController.clear();
    rewardDateController.clear();
  }
}