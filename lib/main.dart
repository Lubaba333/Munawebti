import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studants/controllers/auth_controller.dart';
import 'package:studants/controllers/lecture_attendance_controller.dart';
import 'package:studants/controllers/notification_controller%20.dart';

import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/controllers/reset_password_controller.dart';
import 'package:studants/firebase_options.dart';
import 'package:studants/services/local_notification_service.dart';
import 'package:studants/translations/app_translations.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/utlis/theme_helper.dart';
import 'package:studants/views/main_navigation_view.dart';
import 'package:studants/views/welcome_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  final box = GetStorage();
  if (box.read('language') == null) {
    await box.write('language', 'en');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.init();

  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.put(ThemeController());
  Get.lazyPut<NotificationController>(
    () => NotificationController(),
    fenix: true,
  );
  Get.put(LectureAttendanceController());
  Get.lazyPut<ResetPasswordController>(
    () => ResetPasswordController(),
    fenix: true,
  );

  await initFCM();

  // 🔥 نتحقق هل فيه توكن محفوظ عالجهاز
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('auth_token');
  final bool isLoggedIn = savedToken != null && savedToken.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  String? token = await messaging.getToken();
  print('🟢 TOKEN: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Message arrived');
    LocalNotificationService.showBasicNotification(message);
    Get.find<NotificationController>().getNotifications();
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: Locale(box.read('language') ?? 'en'),
        fallbackLocale: const Locale('en'),

        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.softLavender,
          cardColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: const TextStyle(color: AppColors.black),
            bodyMedium: TextStyle(
              color: AppColors.black.withOpacity(0.7),
            ),
            titleLarge: const TextStyle(
              color: AppColors.darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        themeMode: themeController.themeMode,

        // 🔥 هون القرار: لو فيه توكن روحي على الشاشة الرئيسية، غير هيك روحي على welcome
        home: isLoggedIn ? const MainNavigationView() : const WelcomeView(),
      );
    });
  }
}