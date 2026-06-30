import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisors/services/api_service.dart';


import 'AuthController.dart';

class ProfileController extends GetxController {

  final authController =
      Get.find<AuthController>();

  final ApiService apiService = Get.find<ApiService>();


// ================= RECORDS =================

  final rewards = <dynamic>[].obs;

  final warnings = <dynamic>[].obs;

  final violations = <dynamic>[].obs;


  final isLoadingRecords = false.obs;

  /// UI
  final isEdit = false.obs;
  final isDark = false.obs;

  /// IMAGE
  final imageFile = Rx<File?>(null);

  /// CONTROLLERS
  late TextEditingController nameCtrl;
  late TextEditingController roleCtrl;
  late TextEditingController emailCtrl;

  final picker = ImagePicker();

  /// ================= GETTERS =================

  String get name =>
      authController
          .supervisor
          .value
          ?.fullName ??
      "";

  String get email =>
      authController
          .supervisor
          .value
          ?.email ??
      "";

  String get role =>
      authController
          .supervisor
          .value
          ?.specialization ??
      "";

  String get supervisorId =>
      authController
          .supervisor
          .value
          ?.supervisorIdentifier ??
      "";

  String get certificatePlace =>
      authController
          .supervisor
          .value
          ?.certificatePlace ??
      "";

  String get certificateDate {

    final rawDate =
        authController
            .supervisor
            .value
            ?.certificateDate ??
        "";

    if (rawDate.isEmpty) {
      return "";
    }

    return rawDate.split("T").first;
  }

  /// ================= INIT =================

  @override
  void onInit() {

    super.onInit();

      print(
    authController.supervisor.value?.fullName,
  );


    _initializeControllers();


    getSupervisorRecords();
  }

  void _initializeControllers() {

    nameCtrl = TextEditingController(
      text: name,
    );

    roleCtrl = TextEditingController(
      text: role,
    );

    emailCtrl = TextEditingController(
      text: email,
    );
  }

  /// ================= EDIT =================

  void toggleEdit() {

    isEdit.toggle();
  }

  /// ================= IMAGE PICKER =================

  Future<void> pickImage() async {

    final picked =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      imageFile.value =
          File(picked.path);
    }
  }

  /// ================= THEME =================

  void toggleTheme(bool value) {

    isDark.value = value;

    Get.changeThemeMode(
      value
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }

  Future<void> getSupervisorRecords() async {

    try {

      isLoadingRecords.value = true;


      // ✅ تعريف المتغيرات
      final rewardsResponse = await apiService.get(
        "/supervisor/rewards",
        queryParameters: {
          "received": "1",
        },
      );


      final warningsResponse = await apiService.get(
        "/supervisor/warnings",
        queryParameters: {
          "received": "1",
        },
      );


      final violationsResponse = await apiService.get(
        "/supervisor/violations",
        queryParameters: {
          "received": "1",
        },
      );


      // ✅ تخزين البيانات
      rewards.value =
          rewardsResponse["data"]["data"] ?? [];


      warnings.value =
          warningsResponse["data"]["data"] ?? [];


      violations.value =
          violationsResponse["data"]["data"] ?? [];

    }
    catch (e) {

      print("Error: $e");

    }
    finally {

      isLoadingRecords.value = false;

    }
  }

  /// ================= LOGOUT =================

  Future<void> logout() async {

    await authController.logout();
  }

  /// ================= DISPOSE =================

  @override
  void onClose() {

    nameCtrl.dispose();
    roleCtrl.dispose();
    emailCtrl.dispose();

    super.onClose();
  }
}

