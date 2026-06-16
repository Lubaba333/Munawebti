import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisors/controller/StudentsController.dart';
import 'package:supervisors/controller/emergency_controller.dart';
import 'package:supervisors/controller/request_controller.dart';
import 'package:supervisors/view/onboarding_view.dart';
import 'controller/AuthController.dart';
import 'controller/SettingsController.dart';

void main() async {

 WidgetsFlutterBinding.ensureInitialized();

  /// AUTH
  Get.put(AuthController());

  await GetStorage.init();

    Get.put(SettingsController());

 Get.put(StudentsController());
 Get.put(EmergencyController());
 Get.put(RequestController());

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {

  MyApp({super.key});
  final SettingsController controller = Get.find();
  @override
  Widget build(BuildContext context) {

    return Obx(
      () => GetMaterialApp(

        debugShowCheckedModeBanner: false,

        title: "Munawebti",
         


      /// THEME
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: controller.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,

      /// LANGUAGE
      locale: controller.locale.value,
      fallbackLocale: const Locale('en', 'US'),
        home: OnboardingView(),
      ),
    );
  }
}

