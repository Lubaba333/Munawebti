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
import 'package:supervisors/view/NotificationsView.dart';
import 'package:supervisors/view/chat_view.dart';
import 'package:supervisors/view/onboarding_view.dart';
import 'controller/AuthController.dart';
import 'controller/ChatController.dart';
import 'controller/SettingsController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/notifications_controller.dart';
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
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {

      if (response.payload == null) return;

      final data = response.payload!.split("|");

      if (data.first == "chat") {

        Get.to(
              () => ChatView(
            conversationId: int.parse(data[1]),
            receiverId: int.parse(data[2]),
            receiverName: data[3],
          ),
        );

      } else {

        Get.to(() => NotificationsView());

      }
    },
  );
  
  /// طلب صلاحية الإشعارات صراحة (Android 13+)
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidImplementation != null) {
    await androidImplementation.requestNotificationsPermission();
  }

  //اذا وصل اشعار والتطبيق بالخلفيه
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    print("DATA = ${message.data}");

    print("TITLE = ${message.notification?.title}");
    print("BODY = ${message.notification?.body}");
    if (message.data["type"] == "chat_message") {
      if (Get.isRegistered<ChatController>()) {
        await Get.find<ChatController>().onNewMessageNotification(
          conversationId: int.parse(message.data["conversation_id"]),
          senderId: int.parse(message.data["sender_id"]),
        );
      }
    }
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
        payload: message.data["type"] == "chat_message"
            ? "chat|${message.data["conversation_id"]}|${message.data["sender_id"]}|${message.notification?.title ?? "Chat"}"
            : "notification",
      );
    }

    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().incrementUnreadLocally();
    }

  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔥 onMessageOpenedApp");
    final data = message.data;

    if (data["click_action"] == "OPEN_CHAT") {

      Get.to(
            () => ChatView(
          conversationId: int.parse(data["conversation_id"]),
          receiverId: int.parse(data["sender_id"]),
          receiverName: message.notification?.title ?? "Chat",
        ),
      );

    }  else {

      Get.to(() => NotificationsView());

    }

  });

  /// AUTH
  Get.put(AuthController());
  Get.put(NotificationsController());
  await GetStorage.init();
  Get.put(ChatController(), permanent: true);

  Get.put(SettingsController());
  Get.put(ApiService());
  Get.put(StudentsController());
 Get.put(EmergencyController());
 Get.put(RequestController());
  Get.put(SupervisorShiftsController());
  Get.put(ProfileController());

 // Get.put(AttendanceController());

  runApp(
    MyApp(),
  );

  /// إذا التطبيق فتح بسبب ضغطة على إشعار (كان مقفول تماماً)
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print("🔥 getInitialMessage");
    if (message == null) return;

    final data = message.data;

    if (data["click_action"] == "OPEN_CHAT") {

      Get.to(
            () => ChatView(
          conversationId: int.parse(data["conversation_id"]),
          receiverId: int.parse(data["sender_id"]),
          receiverName: message.notification?.title ?? "Chat",
        ),
      );

    } else {

      Get.to(() => NotificationsView());

    }

  });
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
