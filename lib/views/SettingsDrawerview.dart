// lib/widgets/settings_drawer.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/controllers/settings_drawer_controller.dart';
import 'package:studants/utlis/app_colors.dart';

class SettingsDrawer extends StatefulWidget {
  final VoidCallback? onLogout;

  const SettingsDrawer({super.key, this.onLogout});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late RxBool _isDarkMode;
  late SettingsDrawerController controller;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    controller = Get.put(SettingsDrawerController());
    _isDarkMode = Get.isDarkMode.obs;
  }

  @override
  void dispose() {
    _animController.dispose();
    _isDarkMode.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkPurple, AppColors.mauve],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5),
        ],
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: [
                    _floating(Icons.person, 20, 200),
                    _floating(Icons.favorite, 40, 50),
                    _floating(Icons.settings, 120, 190),
                    _floating(Icons.settings, 150, 40),
                    _floating(Icons.notifications_active, 220, 100),
                    _floating(Icons.person, 350, 125),
                    _floating(Icons.info, 430, 200),
                    _floating(Icons.school, 600, 30),
                    _floating(Icons.settings, 620, 200),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                _buildHeader(),
                const Divider(color: Colors.white24, height: 1),
                Expanded(child: _buildMenuItems()),
                _buildFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final profileController = Get.find<ProfileController>();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Obx(() {
              final img = profileController.profileImage.value;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.white,
                  backgroundImage: img != null ? FileImage(img) : null,
                  child: img == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.darkPurple,
                        )
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              profileController.name.value.isEmpty
                  ? "student".tr
                  : profileController.name.value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                profileController.email.value,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildMenuItems() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        _languagePopupItem(),
        _themeToggleItem(),
        _menuItem(
          Icons.info_outline,
          "about_app".tr,
          "app_version".tr,
          () => _goTo('/about'),
        ),
      ],
    ),
  );
}
Widget _languagePopupItem() {
  return PopupMenuButton<String>(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    onSelected: (value) {
      final box = GetStorage();
      box.write('language', value);
      Get.updateLocale(Locale(value));
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'en',
        child: Row(
          children: [
            Icon(
              Get.locale?.languageCode == 'en'
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: AppColors.darkPurple,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text('English'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'ar',
        child: Row(
          children: [
            Icon(
              Get.locale?.languageCode == 'ar'
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: AppColors.darkPurple,
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text('العربية'),
          ],
        ),
      ),
    ],
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "language".tr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "change_language".tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white70,
          ),
        ],
      ),
    ),
  );
}
  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeToggleItem() {
    return Obx(() {
      final isDark = _isDarkMode.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: (MediaQuery.sizeOf(context).width * 0.75 - 32) * 0.5,
                height: 44,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setTheme(false),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.light_mode,
                            color: !isDark ? Colors.amber : Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "light".tr,
                            style: TextStyle(
                              color: !isDark ? Colors.amber : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setTheme(true),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dark_mode,
                            color: isDark ? Colors.blueAccent : Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "dark".tr,
                            style: TextStyle(
                              color:
                                  isDark ? Colors.blueAccent : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }



  void _setTheme(bool isDark) {
    if (_isDarkMode.value == isDark) return;

    _isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _handleLogout,
        child: Text("logout".tr),
      ),
    );
  }

  Widget _floating(IconData icon, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (_, __) {
          final scale = 0.8 + (_animController.value * 0.6);

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: 0.25 + (_animController.value * 0.2),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void _goTo(String route) {
    Get.back();
    Get.toNamed(route);
  }

  void _handleLogout() {
    final settingsController = Get.find<SettingsDrawerController>();
    settingsController.logout();
  }
}