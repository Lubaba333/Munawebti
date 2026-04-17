import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/AppColors.dart';
import '../controller/DashboardController.dart';

class SlideSidebar extends StatelessWidget {
  const SlideSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    /// نستخدم Obx لمراقبة متغير isSidebarExpanded
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: controller.isSidebarExpanded.value ? 260 : 0,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            if (controller.isSidebarExpanded.value)
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
          ],
        ),
        child: _buildSidebarContent(controller),
      );
    });
  }

  Widget _buildSidebarContent(DashboardController controller) {
    // نستخدم SingleChildScrollView مع SizedBox ثابت العرض
    // لضمان عدم حدوث أخطاء في التصميم (Overflow) أثناء تقلص الشريط
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // لمنع السحب الجانبي اليدوي
      child: SizedBox(
        width: 260, // نحافظ على عرض المحتوى ثابت حتى لو تقلصت الحاوية الأب
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/logoo.jpg'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Nursing Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(controller, "Dashboard", Icons.dashboard, 0),
                  _buildMenuItem(controller, "Users", Icons.people, 1),
                  _buildMenuItem(controller, "Schedules", Icons.calendar_month, 2),
                  _buildMenuItem(controller, "Requests", Icons.request_page, 3),
                  _buildMenuItem(controller, "Reports", Icons.bar_chart, 4),
                ],
              ),
            ),

            /// Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFooterItem(Icons.settings, "Settings"),
                  const SizedBox(height: 12),
                  _buildFooterItem(Icons.logout, "Logout"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة العناصر (Items) تبقى كما هي تقريباً مع التأكد من استخدام controller
  Widget _buildMenuItem(DashboardController controller, String title, IconData icon, int index) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () => controller.changePage(index),
            leading: Icon(icon, color: Colors.white, size: 24),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFooterItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}