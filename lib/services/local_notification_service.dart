import 'dart:convert';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidInit,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    final String? imageUrl = message.notification?.android?.imageUrl;

    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(imageUrl));
      final base64Image = base64Encode(response.bodyBytes);

      bigPictureStyle = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(base64Image),
      );
    }

    final androidDetails = AndroidNotificationDetails(
      'munawebti_channel',
      'Munawebti Notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    final details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      details,
    );
  }
}