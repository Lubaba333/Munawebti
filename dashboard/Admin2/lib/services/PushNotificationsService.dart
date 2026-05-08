import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PushNotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {

    // ✅ طلب الصلاحيات مرة واحدة فقط
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ auth listener واحد فقط
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;

      final token = await _messaging.getToken(
        vapidKey: kIsWeb
            ? "BHmWSye96Wq4wLFMe-I5imfeo1iVhuCyOe34EPunmcmiYLP0Xd795eoiaPJkoWeMFUDr9fu8TOTCXsTj-k7IUQw"
            : null,
      );

      if (token != null) {
        await _saveToken(user.uid, token);
        log('🟢 FCM Token saved: $token');
      }
    });

    // ✅ تحديث التوكن
    _messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _saveToken(user.uid, newToken);
        log('🔥 Token refreshed: $newToken');
      }
    });

    // =========================
    // 📩 Foreground
    // =========================
    FirebaseMessaging.onMessage.listen((message) {
      Get.snackbar(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "",
        snackPosition: SnackPosition.TOP,
      );
    });

    // =========================
    // 📌 Click
    // =========================
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final data = message.data;

      switch (data['type']) {
        case 'login':
          Get.toNamed('/login');
          break;
        case 'order':
          Get.toNamed('/orders');
          break;
        default:
          Get.toNamed('/login');
      }
    });
  }

  // =========================
  // 💾 Save token
  // =========================
  static Future<void> _saveToken(String uid, String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('fcmTokens')
        .doc(token)
        .set({
      'token': token,
      'platform': kIsWeb ? 'web' : 'mobile',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    log("✅ Token saved for user: $uid");
  }
}