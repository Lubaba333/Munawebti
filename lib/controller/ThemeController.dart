// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeController extends GetxController {

//   final isDarkMode = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadTheme();
//   }

//   /// تحميل الثيم المحفوظ
//   Future<void> loadTheme() async {

//     final prefs =
//         await SharedPreferences.getInstance();

//     isDarkMode.value =
//         prefs.getBool('isDarkMode') ?? false;

//     Get.changeThemeMode(
//       isDarkMode.value
//           ? ThemeMode.dark
//           : ThemeMode.light,
//     );
//   }

//   /// تغيير الثيم
//   Future<void> toggleTheme(
//       bool value) async {

//     isDarkMode.value = value;

//     Get.changeThemeMode(
//       value
//           ? ThemeMode.dark
//           : ThemeMode.light,
//     );

//     final prefs =
//         await SharedPreferences.getInstance();

//     await prefs.setBool(
//       'isDarkMode',
//       value,
//     );
//   }
// }