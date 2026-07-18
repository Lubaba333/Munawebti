import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisors/const/app_theme.dart';
import 'package:supervisors/const/app_translations.dart';
import 'package:supervisors/controller/ProfileController.dart';
import 'package:supervisors/controller/StudentsController.dart';
import 'package:supervisors/controller/emergency_controller.dart';
import 'package:supervisors/controller/request_controller.dart';
import 'package:supervisors/controller/supervisor_shift_controller.dart';
import 'package:supervisors/services/api_service.dart';
import 'package:supervisors/view/onboarding_view.dart';
import 'controller/AuthController.dart';
import 'controller/SettingsController.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// AUTH
  Get.put(AuthController());

  await GetStorage.init();

  Get.put(SettingsController());
  Get.put(ApiService());
  Get.put(StudentsController());
  Get.put(EmergencyController());
  Get.put(RequestController());
  Get.put(SupervisorShiftsController());
  Get.put(ProfileController());

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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: controller.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,

        /// LANGUAGE
        translations: AppTranslations(),
        locale: controller.locale.value,
        fallbackLocale: const Locale('en', 'US'),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: OnboardingView(),
      ),
    );
  }
}
