import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإشعارات".tr)),
      body:  Center(
        child: Text("صفحة الإشعارات".tr),
      ),
    );
  }
}