import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/SettingsController.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title:  Text("settings".tr),
        centerTitle: true,
      ),

      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(18),
          children: [

            /// ================= APPEARANCE =================
            _sectionTitle(context, "appearance".tr),
            const SizedBox(height: 10),

            _settingsCard(
              context: context,
              children: [
                _iconTile(
                  context: context,
                  icon: controller.isDarkMode.value
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: "dark_mode".tr,
                  subtitle: controller.isDarkMode.value
                      ? "currently_on".tr
                      : "currently_off".tr,
                  trailing: Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (_) => controller.toggleTheme(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// ================= LANGUAGE =================
            _sectionTitle(context, "language".tr),
            const SizedBox(height: 10),

            _settingsCard(
              context: context,
              children: [
                _languageTile(
                  context: context,
                  flag: const Text("🇬🇧", style: TextStyle(fontSize: 22)),
                  title: "English",
                  value: 'en',
                ),
                _divider(context),
                _languageTile(
                  context: context,
                  flag: _syrianFlagIcon(),
                  title: "العربية",
                  value: 'ar',
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// ================= ABOUT =================
            _sectionTitle(context, "about".tr),
            const SizedBox(height: 10),

            _settingsCard(
              context: context,
              children: [
                _iconTile(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: "about_app".tr,
                  subtitle: "about_app_subtitle".tr,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  onTap: () => _showAboutSheet(context),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: .3,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // ================= CARD WRAPPER =================
  Widget _settingsCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 70,
      color: Theme.of(context).dividerColor,
    );
  }

  // ================= ICON TILE (generic row) =================
  Widget _iconTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  // ================= LANGUAGE TILE =================
  Widget _languageTile({
    required BuildContext context,
    required Widget flag,
    required String title,
    required String value,
  }) {
    final selected = controller.locale.value.languageCode == value;

    return InkWell(
      onTap: () => controller.changeLanguage(value),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            flag,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
          ],
        ),
      ),
    );
  }

  // ================= SYRIAN FLAG  =================
  Widget _syrianFlagIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        width: 28,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: .5),
        ),
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFF007A3D))),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.5),
                      child: Icon(
                        Icons.star,
                        size: 6,
                        color: Color(0xFFCE1126),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  // ================= ABOUT SHEET =================
  void _showAboutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/munawebti.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "munawebti".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                "Version 1.0.0".tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(
                "about_description".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
