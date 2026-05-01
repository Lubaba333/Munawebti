import 'package:admin2/view/UserManagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../view/HousingScreen.dart';
import '../view/ManageSchedulesScreen.dart';
import '../view/Request.dart';
import '../view/dashboard_home.dart';
import '../view/violation.dart';
import 'UserManagement_controller.dart';



class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var isDarkMode = false.obs;
  var isSidebarExpanded = true.obs;

  @override
  void onInit() {
    super.onInit();
    // سجل الـ Controller هنا قبل بناء الصفحات
    Get.put(UserManagementController());
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
  }

  final titles = ["Dashboard", "Users", "Schedules", "Requests", "Housing","Reports"];

  final pages = [
    const DashboardSection(),
    UserManagementScreen(), // هنا الـ Controller يجب أن يكون مسجل مسبقًا
    ManageSchedulesScreen(),
    RequestScreen(),
    BuildingsScreen(),
    ViolationScreen(),
    //Text("Reports"),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout() async {
  try {
  // 1. الوصول للـ ApiService لمسح التوكن من الذاكرة (SharedPreferences)
  final apiService = Get.find<ApiService>();
  await apiService.setToken(''); // مسح التوكن بجعله نص فارغ

  // 2. إظهار رسالة تأكيد
  Get.snackbar(
  "Farewell",
  "You have successfully logged out",
  snackPosition: SnackPosition.BOTTOM,
  );

  // 3. الانتقال لصفحة اللوجن وحذف كل الصفحات السابقة من الذاكرة
  Get.offAllNamed(AppRoutes.login);
  } catch (e) {
  Get.snackbar("Erorr", "Log out failed");
  }
  }
  }