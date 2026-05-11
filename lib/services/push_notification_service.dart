import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:studants/services/local_notification_service.dart';


class PushNotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission();

    final String? token = await _messaging.getToken();
    log('🟢 Firebase Token: ${token ?? "null"}');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
   
    await LocalNotificationService.showBasicNotification(message);
  }

  static Future<void> _handleOpenedApp(RemoteMessage message) async {
    log('📲 Notification Clicked!');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await LocalNotificationService.showBasicNotification(message);
  }
}
