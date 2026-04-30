import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/AppColors.dart';
import '../../routes/app_routes.dart';
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

          /// 🟣 Title
          Obx(() {
            return Text(
              controller.titles[controller.selectedIndex.value],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            );
          }),

          const SizedBox(width: 30),

          /// 🔍 Search
          Expanded(
            child: _FancySearchField(),
          ),

          const SizedBox(width: 20),

          /// 🌙 Theme toggle
          Obx(() {
            return _hoverIcon(
              context: context,
              icon: controller.isDarkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
              onTap:Get.find<ThemeController>().toggleTheme,
            );
          }),

          const SizedBox(width: 10),

          /// 🔔 Notifications
          _hoverIcon(
            context: context,
            icon: Icons.notifications_none,
            badge: "3",
            onTap: () {},
          ),

          const SizedBox(width: 10),

          /// 👤 Profile
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
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
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
              PopupMenuItem(value: "profile", child: Text("Profile")),
              PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 Hover Icon (Theme-aware)
  Widget _hoverIcon({
    required BuildContext context,
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
                    color: isHover
                        ? AppColors.primary
                        : Theme.of(context).iconTheme.color,
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
                        color: Colors.white,
                        fontSize: 10,
                      ),
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
                ? Theme.of(context).cardColor
                : (isHover
                ? Theme.of(context).cardColor.withOpacity(0.8)
                : Theme.of(context).cardColor.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isFocused
                ? [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.15),
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