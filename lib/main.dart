import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisor/controller/AuthController.dart';
import 'package:supervisor/controller/SettingsController.dart';
import 'package:supervisor/view/LoginView.dart';


void main() async {

 WidgetsFlutterBinding.ensureInitialized();

  /// AUTH
  Get.put(AuthController());

  await GetStorage.init();

  Get.put(SettingsController());

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
        home: LoginView(),
      ),
    );
  }
}