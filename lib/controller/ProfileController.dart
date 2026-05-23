import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuthController.dart';

class ProfileController extends GetxController {

  final authController =
      Get.find<AuthController>();
   

  /// UI
  final isEdit = false.obs;
  var isDarkMode = false.obs;

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
void onInit() async {
  super.onInit();

  await _loadSettings();
  _initializeControllers();
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
  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);}

  
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