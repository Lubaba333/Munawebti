// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../const/app_colors.dart';
// import '../controller/ProfileController.dart';

// class ProfileView extends StatelessWidget {
//   ProfileView({super.key});

//   final ProfileController controller =
//       Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,

//       floatingActionButton: Obx(
//         () => FloatingActionButton(
//           backgroundColor: AppColors.primary,
//           onPressed: controller.toggleEdit,
//           child: Icon(
//             controller.isEdit.value
//                 ? Icons.check
//                 : Icons.edit,
//           ),
//         ),
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [

//               /// HEADER
//               _buildHeader(),

//               const SizedBox(height: 25),

//               /// PROFILE INFO
//               _buildInfoCard(),

//               const SizedBox(height: 20),

//               /// SETTINGS
//               _buildSettingsCard(),

//               const SizedBox(height: 20),

//               /// LOGOUT
//               _buildLogoutButton(),

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// ================= HEADER =================
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(
//         top: 35,
//         bottom: 30,
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: AppColors.mainGradient,
//         ),
//         borderRadius:
//             const BorderRadius.vertical(
//           bottom: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [

//           /// PROFILE IMAGE
//           GestureDetector(
//             onTap: () {
//               if (controller.isEdit.value) {
//                 controller.pickImage();
//               }
//             },
//             child: Obx(
//               () => CircleAvatar(
//                 radius: 48,
//                 backgroundColor: Colors.white,
//                 backgroundImage:
//                     controller.imageFile.value !=
//                             null
//                         ? FileImage(
//                             controller
//                                 .imageFile
//                                 .value!,
//                           )
//                         : null,
//                 child:
//                     controller.imageFile.value ==
//                             null
//                         ? Icon(
//                             Icons.person,
//                             size: 45,
//                             color:
//                                 AppColors.primary,
//                           )
//                         : null,
//               ),
//             ),
//           ),

//           const SizedBox(height: 15),

//           /// NAME
//           Obx(
//             () => controller.isEdit.value
//                 ? _buildEditField(
//                     controller.nameCtrl,
//                   )
//                 : Text(
//                     controller.name,
//                     style:
//                         const TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight:
//                           FontWeight.bold,
//                     ),
//                   ),
//           ),

//           const SizedBox(height: 8),

//           /// SPECIALIZATION
//           Obx(
//             () => controller.isEdit.value
//                 ? _buildEditField(
//                     controller.roleCtrl,
//                   )
//                 : Text(
//                     controller.role,
//                     style:
//                         const TextStyle(
//                       color:
//                           Colors.white70,
//                       fontSize: 15,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ================= INFO CARD =================
//   Widget _buildInfoCard() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius:
//             BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [

//           _buildRow(
//             title: "Email",
//             value: controller.email,
//             controller:
//                 controller.emailCtrl,
//           ),

//           _divider(),

//           _buildRow(
//             title: "Supervisor ID",
//             value: controller.supervisorId,
//             controller:
//                 TextEditingController(),
//           ),

//           _divider(),

//           _buildRow(
//             title: "University",
//             value:
//                 controller.certificatePlace,
//             controller:
//                 TextEditingController(),
//           ),

//           _divider(),

//           _buildRow(
//             title: "Certificate Date",
//             value:
//                 controller.certificateDate,
//             controller:
//                 TextEditingController(),
//           ),

//           _divider(),

//           _buildRow(
//             title: "Specialization",
//             value: controller.role,
//             controller:
//                 controller.roleCtrl,
//           ),
//         ],
//       ),
//     );
//   }

//   /// ================= SETTINGS =================
//   Widget _buildSettingsCard() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(
//         horizontal: 20,
//       ),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius:
//             BorderRadius.circular(20),
//       ),
//       child: Obx(
//         () => SwitchListTile(
//           value: controller.isDark.value,
//           onChanged:
//               controller.toggleTheme,
//           title: const Text(
//             "Dark Mode",
//           ),
//         ),
//       ),
//     );
//   }

//   /// ================= LOGOUT =================
//   Widget _buildLogoutButton() {
//     return GestureDetector(
//       onTap: controller.logout,
//       child: Container(
//         margin:
//             const EdgeInsets.symmetric(
//           horizontal: 20,
//         ),
//         padding:
//             const EdgeInsets.symmetric(
//           vertical: 15,
//         ),
//         decoration: BoxDecoration(
//           color:
//               Colors.red.withOpacity(0.1),
//           borderRadius:
//               BorderRadius.circular(18),
//         ),
//         child: const Center(
//           child: Text(
//             "Logout",
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight:
//                   FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// ================= INFO ROW =================
//   Widget _buildRow({
//     required String title,
//     required String value,
//     required TextEditingController
//         controller,
//   }) {
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(
//         vertical: 12,
//       ),
//       child: Row(
//         children: [

//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color:
//                     AppColors.textDark,
//                 fontWeight:
//                     FontWeight.w600,
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Obx(
//               () => this.controller
//                       .isEdit.value
//                   ? TextField(
//                       controller:
//                           controller,
//                       textAlign:
//                           TextAlign.end,
//                       decoration:
//                           const InputDecoration(
//                         border:
//                             InputBorder
//                                 .none,
//                       ),
//                     )
//                   : Text(
//                       value,
//                       textAlign:
//                           TextAlign.end,
//                       style:
//                           TextStyle(
//                         color: AppColors
//                             .textLight,
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ================= EDIT FIELD =================
//   Widget _buildEditField(
//     TextEditingController controller,
//   ) {
//     return SizedBox(
//       width: 220,
//       child: TextField(
//         controller: controller,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//         decoration: const InputDecoration(
//           border: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// ================= DIVIDER =================
//   Widget _divider() {
//     return Divider(
//       color: Colors.grey.shade200,
//       thickness: 1,
//       height: 5,
//     );
//   }
// }




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/ProfileController.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller =
      Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 8,
        onPressed: controller.toggleEdit,
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: Icon(
              controller.isEdit.value
                  ? Icons.check
                  : Icons.edit,
              key: ValueKey(
                controller.isEdit.value,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          child: Column(
            children: [

              /// ================= HEADER =================
              _buildHeader(),

              const SizedBox(height: 20),

              /// ================= INFO CARD =================
              _buildInfoCard(),

              const SizedBox(height: 18),

              /// ================= SETTINGS =================
              _buildSettingsCard(),

              const SizedBox(height: 18),

              /// ================= LOGOUT =================
              _buildLogoutButton(),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// HEADER
  /// =====================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 35,
        bottom: 30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.mainGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            const BorderRadius.vertical(
          bottom: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [

          /// PROFILE IMAGE
          GestureDetector(
            onTap: () {
              if (controller.isEdit.value) {
                controller.pickImage();
              }
            },
            child: Stack(
              alignment:
                  Alignment.bottomRight,
              children: [

                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.15),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor:
                          Colors.white,
                      backgroundImage:
                          controller
                                      .imageFile
                                      .value !=
                                  null
                              ? FileImage(
                                  controller
                                      .imageFile
                                      .value!,
                                )
                              : null,
                      child: controller
                                  .imageFile
                                  .value ==
                              null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors
                                  .primary,
                            )
                          : null,
                    ),
                  ),
                ),

                Obx(
                  () => controller
                          .isEdit.value
                      ? Container(
                          padding:
                              const EdgeInsets
                                  .all(6),
                          decoration:
                              BoxDecoration(
                            color: Colors.white,
                            shape:
                                BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color:
                                AppColors.primary,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// NAME
          Text(
            controller.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// SPECIALIZATION
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: Text(
              controller.role,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// INFO CARD
  /// =====================================================

  Widget _buildInfoCard() {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [

          _buildRow(
            icon: Icons.email_outlined,
            title: "Email",
            value: controller.email,
          ),

          _divider(),

          _buildRow(
            icon: Icons.badge_outlined,
            title: "Supervisor ID",
            value: controller.supervisorId,
          ),

          _divider(),

          _buildRow(
            icon: Icons.school_outlined,
            title: "University",
            value:
                controller.certificatePlace,
          ),

          _divider(),

          _buildRow(
            icon: Icons.calendar_month,
            title: "Certificate Date",
            value:
                controller.certificateDate,
          ),

          _divider(),

          _buildRow(
            icon: Icons.psychology_alt,
            title: "Specialization",
            value: controller.role,
          ),
        ],
      ),
    );
  }

  /// =====================================================
/// SETTINGS CARD
/// =====================================================

Widget _buildSettingsCard() {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 18,
    ),
    decoration: BoxDecoration(
      color: Get.isDarkMode
          ? const Color(0xff1E1E1E)
          : Colors.white,
      borderRadius:
          BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            0.04,
          ),
          blurRadius: 15,
        )
      ],
    ),
    child: Obx(
      () => SwitchListTile(

        /// القيمة الحالية
        value: controller
            .themeController
            .isDarkMode
            .value,

        /// التبديل
        onChanged: controller
            .themeController
            .toggleTheme,

        activeColor:
            AppColors.primary,

        secondary: Icon(
          controller
                  .themeController
                  .isDarkMode
                  .value
              ? Icons.dark_mode
              : Icons.light_mode,
          color: AppColors.primary,
        ),

        title: Text(
          controller
                  .themeController
                  .isDarkMode
                  .value
              ? "Dark Mode"
              : "Light Mode",
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
            color: Get.isDarkMode
                ? Colors.white
                : AppColors.textDark,
          ),
        ),
      ),
    ),
  );
}
  /// =====================================================
  /// LOGOUT BUTTON
  /// =====================================================

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: controller.logout,
      child: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade100,
              Colors.red.shade50,
            ],
          ),
          borderRadius:
              BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.red.withOpacity(0.1),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),

            SizedBox(width: 10),

            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// INFO ROW
  /// =====================================================

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Container(
            padding:
                const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary
                  .withOpacity(0.08),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color:
                        AppColors.textLight,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color:
                        AppColors.textDark,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// DIVIDER
  /// =====================================================

  Widget _divider() {
    return Divider(
      height: 10,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }
}