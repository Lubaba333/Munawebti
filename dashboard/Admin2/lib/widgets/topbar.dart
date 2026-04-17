import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/AppColors.dart';
import '../../routes/app_routes.dart';
import '../controller/DashboardController.dart';

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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 28),
            onPressed: () {
              controller.toggleSidebar(); // استدعاء دالة الفتح والإغلاق
            },
          ),
          /// 🟣 Title
          Obx(() {
            return Text(
              controller.titles[controller.selectedIndex.value],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            );
          }),

          const SizedBox(width: 30),

          /// 🔍 Fancy Animated Search
          Expanded(
            child: _FancySearchField(),
          ),

          const SizedBox(width: 20),

          /// 🌙 Dark Mode Toggle
          Obx(() {
            return _hoverIcon(
              icon: controller.isDarkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
              onTap: controller.toggleTheme,
            );
          }),

          const SizedBox(width: 10),

          /// 🔔 Notifications (Hover)
          _hoverIcon(
            icon: Icons.notifications_none,
            badge: "3",
            onTap: () {},
          ),

          const SizedBox(width: 10),

          /// 👤 Profile Dropdown
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == "logout") {
                Get.offAllNamed(AppRoutes.login);
              }
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Admin",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Super Admin",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "profile",
                child: Text("Profile"),
              ),
              const PopupMenuItem(
                value: "logout",
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 Hover Icon Widget (Reusable)
  Widget _hoverIcon({
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHover = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHover = true),
          onExit: (_) => setState(() => isHover = false),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isHover
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    icon,
                    size: 26,
                    color:
                    isHover ? AppColors.primary : Colors.grey.shade700,
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

/// 🔮 Fancy Search Field Widget
class _FancySearchField extends StatefulWidget {
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
            color: isFocused
                ? Colors.white
                : (isHover ? Colors.grey.shade50 : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused
                  ? AppColors.primary
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isFocused
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: isFocused
                    ? AppColors.primary
                    : (isHover ? AppColors.primary.withOpacity(0.7) : Colors.grey.shade700),
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