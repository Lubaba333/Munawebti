import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/AppColors.dart';
import '../controller/DashboardController.dart';
import '../controller/theme_controller.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      /// ✅ مهم: منع overflow
      child: Row(
        children: [

          /// ☰ Menu
          IconButton(
            icon: Icon(
              Icons.menu,
              size: 28,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: controller.toggleSidebar,
          ),

          const SizedBox(width: 10),

          /// 🟣 Title (FIXED Obx)
          Obx(() {
            final index = controller.selectedIndex.value;

            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                controller.titles[index],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            );
          }),

          const SizedBox(width: 20),

          /// 🔍 Search (FIXED overflow handling)
          Expanded(
            flex: 3,
            child: _FancySearchField(),
          ),

          const SizedBox(width: 20),

          /// 🌙 Theme toggle (FIXED callback)
          Obx(() {
            return _iconButton(
              context: context,
              icon: controller.islightMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
              onTap: () => Get.find<ThemeController>().toggleTheme(),
            );
          }),

          const SizedBox(width: 10),

          /// 🔔 Notifications
          _iconButton(
            context: context,
            icon: Icons.notifications_none,
            badge: "3",
            onTap: () {},
          ),

          const SizedBox(width: 10),

          /// 👤 Profile (unchanged but safe)
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == "logout") {
                controller.logout();
              }
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 8),

                /// 🔥 Prevent overflow here too
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Admin",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Super Admin",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),

                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                )
              ],
            ),
            itemBuilder: (context) => const [
              PopupMenuItem(value: "profile", child: Text("الملف الشخصي")),
              PopupMenuItem(value: "logout", child: Text("تسجيل الخروج")),
            ],
          ),
        ],
      ),
    );
  }

  /// =========================
  /// ICON BUTTON FIXED
  /// =========================
  Widget _iconButton({
    required BuildContext context,
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 26,
              color: Theme.of(context).iconTheme.color,
            ),
          ),

          if (badge != null)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
class _FancySearchField extends StatefulWidget {
  const _FancySearchField({super.key});

  @override
  State<_FancySearchField> createState() => _FancySearchFieldState();
}

class _FancySearchFieldState extends State<_FancySearchField> {
  bool isFocused = false;
  bool isHover = false;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) => setState(() => isFocused = focus),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHover = true),
        onExit: (_) => setState(() => isHover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 45,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: isFocused
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}