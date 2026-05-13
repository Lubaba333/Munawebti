import 'package:admin2/routes/app_pages.dart';
import 'package:admin2/routes/app_routes.dart';
import 'package:admin2/services/PushNotificationsService.dart';
import 'package:admin2/services/api_service.dart';
import 'package:admin2/widgets/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/DashboardController.dart';
import 'controller/DormitoryUnitController.dart';
import 'controller/SubjectController.dart';
import 'firebase_options.dart';


import 'controller/UserManagement_controller.dart';
import 'controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotificationsService.init();

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

      initialBinding: InitialBinding(), // 🔥 هون كل شي

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService(), fenix: true);

    Get.lazyPut(() => UserManagementController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ThemeController(), fenix: true);

    Get.lazyPut(() => DormitoryUnitController(), fenix: true);
    Get.lazyPut(() => SubjectController(), fenix: true);
  }
}