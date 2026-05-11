// lib/widgets/settings_drawer.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  
  // ✅ متغير تفاعلي لمتابعة حالة الثيم (داخل الـ State)
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
    // ✅ تهيئة حالة الثيم الحالية
    _isDarkMode = Get.isDarkMode.obs;
  }

  @override
  void dispose() {
    _animController.dispose();
    _isDarkMode.close(); // ✅ إغلاق المتغير التفاعلي
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
            /// 🎨 خلفية أنيميشن
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

            /// 📱 المحتوى
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

  // ================= HEADER =================
  Widget _buildHeader() {
    final controller = Get.find<ProfileController>();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Obx(() {
              final img = controller.profileImage.value;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 2),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.white,
                  backgroundImage: img != null ? FileImage(img) : null,
                  child: img == null
                      ? const Icon(Icons.person,
                          size: 50, color: AppColors.darkPurple)
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.name.value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 8),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.email.value,
                  style: const TextStyle(
                      color: AppColors.white, fontSize: 14),
                ),
              )),
        ],
      ),
    );
  }

  // ================= MENU =================
  Widget _buildMenuItems() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        _menuItem(Icons.language, 'اللغة', 'تغيير اللغة',
            () => _goTo('/language')),
        
        // ✅ زر الثيم المتحرك (داخل الـ State الآن)
        _themeToggleItem(),
        
        _menuItem(Icons.info_outline, 'حول التطبيق', 'معلومات الإصدار',
            () => _goTo('/about')),
      ]),
    );
  }

  Widget _menuItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
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
          child: Row(children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ================= THEME TOGGLE =================
  // ✅ هذه الدالة الآن داخل الـ State وتصل لـ _isDarkMode
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
            // 🎯 المؤشر المتحرك
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

            // 🌞 + 🌙 الأزرار
            Row(
              children: [
                // ☀️ فاتح
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setTheme(false),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.light_mode,
                              color: !isDark ? Colors.amber : Colors.white70,
                              size: 18),
                          const SizedBox(width: 6),
                          Text("فاتح",
                              style: TextStyle(
                                color: !isDark ? Colors.amber : Colors.white70,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                // 🌙 داكن
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setTheme(true),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dark_mode,
                              color: isDark ? Colors.blueAccent : Colors.white70,
                              size: 18),
                          const SizedBox(width: 6),
                          Text("داكن",
                              style: TextStyle(
                                color: isDark ? Colors.blueAccent : Colors.white70,
                                fontWeight: FontWeight.bold,
                              )),
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

  // ✅ دالة تبديل الثيم (داخل الـ State)
  void _setTheme(bool isDark) {
    if (_isDarkMode.value == isDark) return;
    _isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _handleLogout,
        child: const Text('تسجيل الخروج'),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _floating(IconData icon, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (_, __) {
          double scale = 0.8 + (_animController.value * 0.6);
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
  final controller = Get.find<SettingsDrawerController>();
  controller.logout(); // ✅
}
}