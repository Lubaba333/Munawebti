import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';





/// إعداد الإشعارات المحلية
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// هاندلر خاص بحالة التطبيق مقفول تماماً (Background/Terminated)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// تسجيل الهاندلر لحالة الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// إعداد الإشعارات المحلية (Android)
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
  
  /// طلب صلاحية الإشعارات صراحة (Android 13+)
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidImplementation != null) {
    await androidImplementation.requestNotificationsPermission();
  }

  /// الاستماع للإشعارات وقت التطبيق مفتوح (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground message: ${message.notification?.title}");

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  /// وقت المستخدم يضغط ع الإشعار والتطبيق كان بالخلفية
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("👉 User tapped notification: ${message.data}");
    // هون لاحقاً منضيف كود التنقل (Navigation) حسب نوع الإشعار
  });

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
