import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/controllers/settings_drawer_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/utlis/theme_helper.dart';

class SettingsDrawer extends StatefulWidget {
  final VoidCallback? onLogout;

  const SettingsDrawer({super.key, this.onLogout});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  final ThemeController themeController = Get.find<ThemeController>();

  final SettingsDrawerController controller =
      Get.isRegistered<SettingsDrawerController>()
          ? Get.find<SettingsDrawerController>()
          : Get.put(SettingsDrawerController());

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  LinearGradient _drawerGradient() {
    return Get.isDarkMode
        ? const LinearGradient(
            colors: [
              Color(0xFF2A1230),
              Color(0xFF3A1B42),
              Color(0xFF121212),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [
              AppColors.darkPurple,
              AppColors.mauve,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.75,
      decoration: BoxDecoration(
        gradient: _drawerGradient(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Get.isDarkMode ? .45 : .26),
            blurRadius: 20,
            spreadRadius: 5,
          ),
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
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.28),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Get.isDarkMode
                      ? const Color(0xFF241826)
                      : AppColors.white,
                  backgroundImage: img != null ? FileImage(img) : null,
                  child: img == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Get.isDarkMode
                              ? AppColors.mauve
                              : AppColors.darkPurple,
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
              textAlign: TextAlign.center,
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
                color: Colors.white.withOpacity(.22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(.15)),
              ),
              child: Text(
                profileController.email.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
      color: Get.isDarkMode ? const Color(0xFF241826) : Colors.white,
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
                color: Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'English',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
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
                color: Get.isDarkMode ? AppColors.mauve : AppColors.darkPurple,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'العربية',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
      child: _drawerItemContainer(
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

  Widget _drawerItemContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(Get.isDarkMode ? .08 : .12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(Get.isDarkMode ? .16 : .22),
        ),
      ),
      child: child,
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
        child: _drawerItemContainer(
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
      final isDark = themeController.isDarkMode.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDark ? .08 : .12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.18)),
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
                  color: Colors.white.withOpacity(.24),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => themeController.setTheme(false),
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
                    onTap: () => themeController.setTheme(true),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dark_mode,
                            color: isDark
                                ? const Color(0xFFD9B5D5)
                                : Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "dark".tr,
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFD9B5D5)
                                  : Colors.white70,
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout_rounded),
        label: Text("logout".tr),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.darkPurple,
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
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
              opacity: 0.20 + (_animController.value * 0.18),
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
    controller.logout();
  }
}