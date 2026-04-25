import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/app_colors.dart';
import '../controllers/home_controller.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Drawer(
      child: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                Text("Ghaeda",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("ID: 20231234",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [

                /// 🌙 DARK MODE
                Obx(() => SwitchListTile(
                      value: controller.isDarkMode.value,
                      onChanged: (v) =>
                          controller.isDarkMode.value = v,
                      secondary: const Icon(Icons.dark_mode),
                      title: const Text("الوضع الليلي"),
                    )),

                /// 🌍 LANGUAGE
                Obx(() => ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                          "اللغة: ${controller.selectedLanguage.value}"),
                      onTap: () {
                        controller.selectedLanguage.value =
                            controller.selectedLanguage.value ==
                                    "العربية"
                                ? "English"
                                : "العربية";
                      },
                    )),

                const Divider(),

                /// 🚪 LOGOUT
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: "تأكيد",
                      middleText: "هل تريد تسجيل الخروج؟",
                      textConfirm: "نعم",
                      textCancel: "إلغاء",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.offAllNamed('/login');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}