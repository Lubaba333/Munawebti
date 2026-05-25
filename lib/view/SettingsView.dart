import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/controller/SettingsController.dart';


class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: Obx(() => Column(
        children: [

          /// ================= DARK MODE =================
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: controller.isDarkMode.value,
            onChanged: (_) => controller.toggleTheme(),
          ),

          const Divider(),

          /// ================= LANGUAGE =================
          ListTile(
            title: const Text("Language"),
          ),

          RadioListTile(
            title: const Text("English"),
            value: 'en',
            groupValue: controller.locale.value.languageCode,
            onChanged: (value) => controller.changeLanguage('en'),
          ),

          RadioListTile(
            title: const Text("العربية"),
            value: 'ar',
            groupValue: controller.locale.value.languageCode,
            onChanged: (value) => controller.changeLanguage('ar'),
          ),
        ],
      )),
    );
  }
}