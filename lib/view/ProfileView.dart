import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ProfileController.dart';
import 'package:supervisors/view/RewardsPage.dart';
import 'package:supervisors/view/WarningsPage.dart';
import 'package:supervisors/view/ViolationsPage.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 8,
        onPressed: controller.toggleEdit,
        child: Obx(
              () =>
              AnimatedSwitcher(
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

              _buildRecordsCard(context),

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
                  () =>
                  CircleAvatar(
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
              color: Theme
                  .of(context)
                  .colorScheme
                  .onBackground,
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
        color: Theme
            .of(context)
            .cardColor,
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
            "email".tr,
            controller.email,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.badge_outlined,
            "supervisor_id".tr,
            controller.supervisorId,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.school_outlined,
            "university".tr,
            controller.certificatePlace,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.calendar_month,
            "certificate_date".tr,
            controller.certificateDate,
          ),

          _divider(),

          _buildRow(
            context,
            Icons.psychology_alt,
            "specialization".tr,
            controller.role,
          ),
        ],
      ),
    );
  }

  // ================= ROW =================
  Widget _buildRow(BuildContext context,
      IconData icon,
      String title,
      String value,) {
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
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color: Theme
                        .of(context)
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

  // ================= RECORDS CARD =================

  Widget _buildRecordsCard(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRecords.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }


      return Container(

        margin: const EdgeInsets.symmetric(horizontal: 18),

        padding: const EdgeInsets.all(20),


        decoration: BoxDecoration(

          color: Theme
              .of(context)
              .cardColor,

          borderRadius: BorderRadius.circular(28),

          boxShadow: const [

            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )

          ],

        ),


        child: Column(


          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Row(

              children: [


                Container(

                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(

                    color: AppColors.primary.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(14),

                  ),


                  child: Icon(

                    Icons.workspace_premium,

                    color: AppColors.primary,

                  ),

                ),


                const SizedBox(width: 12),


                Text(

                  "performance_records".tr,

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                    color: Theme
                        .of(context)
                        .colorScheme
                        .onBackground,

                  ),

                ),


              ],

            ),


            const SizedBox(height: 20),


            Row(

              children: [


                Expanded(

                  child: _recordItem(

                    icon: Icons.card_giftcard,

                    title: "rewards".tr,

                    count: controller.rewards.length.toString(),

                    color: Colors.green,

                    onTap: () {
                      Get.to(() => RewardsPage(),);
                    },
                  ),

                ),


                const SizedBox(width: 10),


                Expanded(

                  child: _recordItem(

                    icon: Icons.warning_amber,

                    title: "warnings".tr,

                    count: controller.warnings.length.toString(),

                    color: Colors.orange,
                    onTap: () {
                      Get.to(() => WarningsPage(),);
                    },
                  ),

                ),


                const SizedBox(width: 10),


                Expanded(

                  child: _recordItem(

                    icon: Icons.report_problem,

                    title: "violations".tr,

                    count: controller.violations.length.toString(),

                    color: Colors.red,
                    onTap: () {
                      Get.to(() => ViolationsPage(),);
                    },
                  ),

                ),


              ],

            )

          ],

        ),

      );
    });
  }

  Widget _recordItem({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(

        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
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
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text(
              "logout".tr,
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

