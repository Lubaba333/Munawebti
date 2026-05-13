import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var isEdit = false.obs;
  var isDark = false.obs;

  var name = "Sara Ahmed".obs;
  var role = "Supervisor".obs;
  var email = "sara@mail.com".obs;
  var phone = "+963 987 654".obs;

  var imageFile = Rx<File?>(null);

  late TextEditingController nameCtrl;
  late TextEditingController roleCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  final picker = ImagePicker();

  @override
  void onInit() {
    nameCtrl = TextEditingController(text: name.value);
    roleCtrl = TextEditingController(text: role.value);
    emailCtrl = TextEditingController(text: email.value);
    phoneCtrl = TextEditingController(text: phone.value);
    super.onInit();
  }

  void toggleEdit() {
    if (isEdit.value) {
      name.value = nameCtrl.text;
      role.value = roleCtrl.text;
      email.value = emailCtrl.text;
      phone.value = phoneCtrl.text;
    }
    isEdit.toggle();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  void toggleTheme(bool value) {
    isDark.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void logout() {
    Get.offAllNamed("/login");
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    roleCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}