import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ProfileController.dart';
import '../const/app_colors.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 8,
        onPressed: controller.toggleEdit,
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              controller.isEdit.value ? Icons.check : Icons.edit,
              key: ValueKey(controller.isEdit.value),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              _buildHeader(context),

              const SizedBox(height: 20),

              _buildInfoCard(context),

              const SizedBox(height: 18),

              _buildLogoutButton(context),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 35, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.mainGradient,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [

          /// IMAGE
          GestureDetector(
            onTap: () {
              if (controller.isEdit.value) {
                controller.pickImage();
              }
            },
            child: Obx(
              () => CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white,
                backgroundImage: controller.imageFile.value != null
                    ? FileImage(controller.imageFile.value!)
                    : null,
                child: controller.imageFile.value == null
                    ? Icon(Icons.person,
                        size: 50, color: AppColors.primary)
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// NAME
          Text(
            controller.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// ROLE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              controller.role,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO CARD =================
  Widget _buildInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [

          _buildRow(
            context,
            Icons.email_outlined,
            "Email",
            controller.email,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.badge_outlined,
            "Supervisor ID",
            controller.supervisorId,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.school_outlined,
            "University",
            controller.certificatePlace,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.calendar_month,
            "Certificate Date",
            controller.certificateDate,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.psychology_alt,
            "Specialization",
            controller.role,
          ),
        ],
      ),
    );
  }

  // ================= ROW =================
  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DIVIDER =================
  Widget _divider() {
    return const Divider(height: 10, thickness: 1);
  }

  // ================= LOGOUT =================
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade100,
              Colors.red.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}