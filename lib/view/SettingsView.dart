import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/SettingsController.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ما في داعي لتحديد لون هون، AppBarTheme بالثيم بيتكفل فيه
      appBar: AppBar(title: const Text("Settings")),

      body: Obx(() => Column(
        children: [

          /// ================= DARK MODE =================
          SwitchListTile(
            title: Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: controller.isDarkMode.value,
            onChanged: (_) => controller.toggleTheme(),
          ),

          const Divider(),

          /// ================= LANGUAGE =================
          ListTile(
            title: Text(
              "Language",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          RadioListTile(
            title: Text(
              "English",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: 'en',
            groupValue: controller.locale.value.languageCode,
            onChanged: (value) => controller.changeLanguage('en'),
          ),

          RadioListTile(
            title: Text(
              "العربية",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: 'ar',
            groupValue: controller.locale.value.languageCode,
            onChanged: (value) => controller.changeLanguage('ar'),
          ),
        ],
      )),
    );
  }
}
