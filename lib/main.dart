import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/profile_controller.dart';

import 'package:studants/firebase_options.dart';
import 'package:studants/services/local_notification_service.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/home_view.dart';
import 'package:studants/views/login.dart';
import 'package:studants/views/register_view.dart';
import 'package:studants/views/welcome_view.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


    // 🔥 init local notifications
  await LocalNotificationService.init();
Get.put(ProfileController());
  // 🔥 init FCM
  await initFCM();
  runApp(const MyApp());
}

Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  // 🔥 طباعة التوكن
  String? token = await messaging.getToken();
  print('🟢 TOKEN: $token');

  // 🔥 لما التطبيق مفتوح
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Message arrived');

    // 👇 هون أهم سطر
    LocalNotificationService.showBasicNotification(message);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.softLavender,
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.black.withOpacity(0.7)),
      titleLarge: TextStyle(color: AppColors.darkPurple, fontWeight: FontWeight.bold),
    ),
  ),

  darkTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // ✅ خلفية غامقة مريحة للعين
    cardColor: const Color(0xFF1E1E1E),              // ✅ بطاقات أغمق قليلاً
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),

  themeMode: ThemeMode.system, // أو Get.isDarkMode.obs
  // ...
   home:LoginView(),);
  }
}