import 'package:admin2/widgets/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/UserManagement_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(UserManagementController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}