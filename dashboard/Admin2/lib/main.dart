import 'package:admin2/routes/app_pages.dart';
import 'package:admin2/routes/app_routes.dart';
import 'package:admin2/services/api_service.dart';
import 'package:admin2/widgets/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/HousingController.dart';
import 'controller/UserManagement_controller.dart';
import 'controller/theme_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.lazyPut(()=>ApiService());
  Get.put(UserManagementController());
  Get.put(HousingController());
  Get.put(ThemeController());
  runApp(const MyApp()); }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      /// 👇 هذا أهم تعديل
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}