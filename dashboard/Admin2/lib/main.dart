import 'package:admin2/routes/app_pages.dart';
import 'package:admin2/routes/app_routes.dart';
import 'package:admin2/services/PushNotificationsService.dart';
import 'package:admin2/services/api_service.dart';
import 'package:admin2/widgets/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/DashboardController.dart';
import 'firebase_options.dart'; // ✅ مهم جدًا

import 'controller/HousingController.dart';
import 'controller/UserManagement_controller.dart';
import 'controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Storage
  await GetStorage.init();

  // ✅ Firebase init الصحيح
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  Get.put(ApiService());
  await PushNotificationsService.init();
  Get.put(UserManagementController());
  Get.put(HousingController());
  Get.put(DashboardController());
  Get.put(ThemeController());

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
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}