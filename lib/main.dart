import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supervisor/controller/AuthController.dart';
import 'package:supervisor/controller/ThemeController.dart';

import 'package:supervisor/view/LoginView.dart';

void main() async {

 WidgetsFlutterBinding.ensureInitialized();

  /// AUTH
  Get.put(AuthController());

  /// THEME
  Get.put(ThemeController());

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  final ThemeController themeController =
      Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => GetMaterialApp(

        debugShowCheckedModeBanner: false,

        title: "Munawebti",

        /// ================= LIGHT THEME =================
        theme: ThemeData(

          brightness: Brightness.light,

          fontFamily: "Poppins",

          scaffoldBackgroundColor:
              const Color(0xFFF5EFE7),

          primaryColor:
              const Color(0xff6C63FF),

          appBarTheme: const AppBarTheme(
            backgroundColor:
                Color(0xFFF5EFE7),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),

          cardColor: Colors.white,
        ),

        /// ================= DARK THEME =================
        darkTheme: ThemeData(

          brightness: Brightness.dark,

          fontFamily: "Poppins",

          scaffoldBackgroundColor:
              const Color(0xff121212),

          primaryColor:
              const Color(0xff6C63FF),

          appBarTheme: const AppBarTheme(
            backgroundColor:
                Color(0xff121212),
            elevation: 0,
            centerTitle: true,
          ),

          cardColor:
              const Color(0xff1E1E1E),
        ),

        /// ================= THEME MODE =================
        themeMode:
            themeController
                    .isDarkMode
                    .value
                ? ThemeMode.dark
                : ThemeMode.light,

        home: LoginView(),
      ),
    );
  }
}