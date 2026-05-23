// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supervisor/controller/AuthController.dart';
// import 'package:supervisor/controller/ProfileController.dart';
// import 'package:supervisor/view/LoginView.dart';

// void main() async {

//  WidgetsFlutterBinding.ensureInitialized();

//   /// AUTH
//   Get.put(AuthController());
// final ProfileController profileController = Get.put(ProfileController());
//   /// THEME
//   // Get.put(ThemeController());

//   runApp(
//     MyApp(),
//   );
// }

// class MyApp extends StatelessWidget {

//   MyApp({super.key});

//   // final ThemeController themeController =
//   //     Get.find<ThemeController>();

//   @override
//   Widget build(BuildContext context) {

//     return Obx(
//       () => GetMaterialApp(

//         debugShowCheckedModeBanner: false,

//         theme: ThemeData.light(),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.grey[900],
//         primaryColor: Colors.grey[800],
//         cardColor: Colors.grey[850],
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.grey[850],
//           iconTheme: const IconThemeData(color: Colors.white),
//           titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white70),
//         ),
//         switchTheme: SwitchThemeData(
//           thumbColor: MaterialStatePropertyAll(Colors.grey),
//           trackColor: MaterialStatePropertyAll(Colors.white24),
//         ),
//         dropdownMenuTheme: DropdownMenuThemeData(

//           textStyle: const TextStyle(color: Colors.white),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.grey[700],
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
// themeMode: profileController.isDarkMode.value
//     ? ThemeMode.dark
//     : ThemeMode.light,

//         home: LoginView(),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/controller/AuthController.dart';
import 'package:supervisor/controller/ProfileController.dart';
import 'package:supervisor/view/LoginView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Controllers
  Get.put(AuthController());
  Get.put(ProfileController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      /// LIGHT THEME
      theme: ThemeData.light(),

      /// DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.grey[800],
        cardColor: Colors.grey[850],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle:
              const TextStyle(color: Colors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStatePropertyAll(Colors.grey),
          trackColor: MaterialStatePropertyAll(Colors.white24),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
          ),
        ),
      ),

      /// THEME MODE (🔥 FIXED)
      themeMode: profileController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,

      home: LoginView(),
    );
  }
}