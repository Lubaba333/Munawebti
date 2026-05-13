import 'package:admin2/view/UserManagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../view/DormitoryUnitsScreen.dart';
import '../view/ManageSchedulesScreen.dart';
import '../view/Request.dart';
import '../view/SectionScreen.dart';
import '../view/SubjectListScreen.dart';
import '../view/dashboard_home.dart';
import '../view/violation.dart';
import 'UserManagement_controller.dart';



class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var islightMode = false.obs;
  var isSidebarExpanded = true.obs;

  @override
  void onInit() {
    super.onInit();
    // سجل الـ Controller هنا قبل بناء الصفحات
    Get.put(UserManagementController());
  }

  void toggleTheme() {
    islightMode.value = !islightMode.value;
    Get.changeThemeMode(
      islightMode.value ? ThemeMode.light: ThemeMode.dark,
    );
  }

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
  }

  final titles = ["Dashboard", "Users", "Schedules", "Requests", "Housing","Sections","Subject"];

  final pages = [
    const DashboardSection(),
    UserManagementScreen(),
    ManageSchedulesScreen(),
    RequestScreen(),
    DormitoryUnitView(),
    SectionScreen(),
    SubjectListScreen(),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout() async {
  try {

  final ApiService apiService = Get.find<ApiService>();
  await apiService.setToken(''); // مسح التوكن


  Get.snackbar(
  "success",
  "You have successfully logged out",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.green.withOpacity(0.1),
  );

  Get.offAllNamed(AppRoutes.login);
  } catch (e) {
  Get.snackbar("Erorr", "Logout failed, please try again.");
  }
  }
  }
