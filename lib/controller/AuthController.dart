
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/view/LoginView.dart';

import '../models/supervisor_model.dart';
import '../services/api_service.dart';
import '../view/MainView.dart';

class AuthController extends GetxController { 


  final ApiService _api = ApiService();
 
  /// FORM
  final email = ''.obs;
  final password = ''.obs;

  /// UI
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  /// USER
  final supervisor = Rxn<SupervisorModel>();

  void togglePassword() {
    isPasswordHidden.toggle();
  }

  void toggleRemember(bool? value) {
    rememberMe.value = value ?? false;
  }

  /// LOGIN
  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final response = await _api.post(
        '/auth/supervisor/login',
        {
          "email": email.value.trim(),
          "password": password.value.trim(),
        },
        authRequired: false,
      );

      final statusCode =
          response['status_code'];

      if (statusCode == 200) {

        final token =
            response['data']['token'];

       await _api.setToken(token);

        await getSupervisorProfile();

        Get.offAll(() => MainView());

        // Get.snackbar(
        //   "Success",
        //   response['message'],
        // );

      } else {
        _showError(
          response['message'],
        );
      }
    } catch (e) {
      _showError(
        e.toString().replaceFirst(
          "Exception: ",
          "",
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// GET CURRENT SUPERVISOR
 Future<void> getSupervisorProfile() async {
  try {

    final response = await _api.get(
      '/auth/supervisor/me',
    );

    print("✅ PROFILE RESPONSE: $response");

    if (response['status_code'] == 200) {

      supervisor.value =
          SupervisorModel.fromJson(
        response['data']['supervisor'],
      ); 
      print(supervisor.value?.fullName);
      print(supervisor.value?.email);
      print(supervisor.value?.specialization);

      print(
        "✅ USER LOADED: ${supervisor.value?.fullName}",
      );
    }

  } catch (e) {

    print(
      "❌ PROFILE ERROR: $e",
    );
  }
}

  /// LOGOUT
Future<void> logout() async {

  try {

    await _api.post(
      '/auth/supervisor/logout',
      {},
    );

  } catch (e) {

    print("❌ LOGOUT API ERROR: $e");
  }

  /// حذف التوكن
  await _api.setToken(null);

  /// حذف بيانات المستخدم
  supervisor.value = null;

  /// الرجوع لصفحة تسجيل الدخول
  Get.offAll(() => LoginView());
}

  bool _validateInputs() {

    if (email.value.isEmpty) {
      _showError("Enter email");
      return false;
    }

    if (!GetUtils.isEmail(email.value)) {
      _showError("Invalid email");
      return false;
    }

    if (password.value.isEmpty) {
      _showError("Enter password");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor:
          Colors.red.shade100,
    );
  }
}