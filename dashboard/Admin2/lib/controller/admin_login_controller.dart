import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/login_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class AdminLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ApiService _apiService = Get.find<ApiService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.post(
        '/auth/admin/login',
        {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
        authRequired: false,
      );

      Welcome loginResponse = Welcome.fromJson(response);

      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {

        await _apiService.setToken(loginResponse.data.token);

        Get.snackbar(
          "success",
          "Hey, you${loginResponse.data.admin.name}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
        );

        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        errorMessage.value = loginResponse.message;
      }

    } catch (e) {
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}