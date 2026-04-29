/// =======================================================
/// UserManagementScreen.dart
/// =======================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/UserManagement_controller.dart';
import '../widgets/AppColors.dart';

class UserManagementScreen extends StatelessWidget {

  UserManagementScreen({super.key});

  final c = Get.put(UserManagementController());

  final Gradient headerGradient =
  const LinearGradient(
    colors: [
      Color(0xFF5A0891),
      Color(0xFF8E2DE2),
    ],
  );

  final List<String> filters = [
    "All",
    "Nurses",
    "Students",
    "Deleted",
  ];

  final RxInt animationKey = 0.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(



      backgroundColor: AppColors.background,

      main

      appBar: PreferredSize(
        preferredSize:
        const Size.fromHeight(70),

        child: Container(
          decoration: BoxDecoration(
            gradient: headerGradient,
          ),

          child: AppBar(
            backgroundColor:
            Colors.transparent,

            elevation: 0,

            title: const Text(
              "User Management",

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          /// ================= FILTERS =================

          _buildFilters(),
main

          const SizedBox(height: 10),

          /// ================= GRID =================
          Expanded(
            child: Obx(() {

              final list =
                  c.filteredUsers;

              return AnimatedSwitcher(

                duration:
                const Duration(
                  milliseconds: 500,
                ),

                child: GridView.builder(

                  key: ValueKey(
                    animationKey.value,
                  ),

                  padding:
                  const EdgeInsets.all(6),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 5,

                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,

                    childAspectRatio: 0.78,
                  ),

                  itemCount: list.length,

                  itemBuilder:
                      (context, i) {

                    return _animatedUser(
                      context,
                      list[i],
                      i,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        AppColors.primary,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () =>
            _showForm(context),
      ),
    );
  }

  /// =======================================================
  /// FILTERS
  /// =======================================================


  Widget _buildFilters() {
main

    return Obx(() {

      return Row(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: filters.map((f) {

          final active =
              c.filter.value == f;

          return GestureDetector(

            onTap: () {

              c.setFilter(f);

              animationKey.value++;
            },

            child: AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 400,
              ),

              margin:
              const EdgeInsets.symmetric(
                horizontal: 6,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),


              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : Colors.white,

                borderRadius:
                BorderRadius.circular(25),
 main
              ),

              child: Text(
                f,

                style: TextStyle(
                  color: active

                      ? Colors.white
                      : AppColors.primary,

                  fontWeight:
                  FontWeight.bold,
 main
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  /// =======================================================
  /// USER ANIMATION
  /// =======================================================

  Widget _animatedUser(
      BuildContext context,
      User user,
      int index,
      ) {

    final direction = index % 4;

    final Offset startOffset =
    switch (direction) {

      0 =>
      const Offset(-150, -120),

      1 =>
      const Offset(150, -120),

      2 =>
      const Offset(-150, 120),

      _ =>
      const Offset(150, 120),
    };

    return TweenAnimationBuilder<double>(

      key: ValueKey(
        user.name +
            animationKey.value
                .toString(),
      ),

      duration: Duration(
        milliseconds:
        900 + index * 80,
      ),

      curve: Curves.easeOutCubic,

      tween: Tween(
        begin: 0,
        end: 1,
      ),

      builder:
          (context, value, child) {

        return Transform.translate(

          offset: Offset(
            startOffset.dx *
                (1 - value),

            startOffset.dy *
                (1 - value),
          ),

          child: Opacity(

            opacity: value,

            child: Transform.scale(

              scale:
              0.6 + (value * 0.4),

              child: child,
            ),
          ),
        );
      },

      child: _userCard(
        context,
        user,
      ),
    );
  }

  /// =======================================================
  /// USER CARD
  /// =======================================================

  Widget _userCard(
      BuildContext context,
      User user,
      ) {

    final isNurse =
        user.role == "Nurse";

    return GestureDetector(

      onTap: user.isDeleted
          ? null
          : () => _showDetails(
        context,
        user,
      ),

      child: Stack(
        children: [

          /// ================= CARD =================
          Opacity(

            opacity:
            user.isDeleted
                ? 0.4
                : 1,

            child: Column(
              mainAxisSize:
              MainAxisSize.min,

              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    50,
                  ),

                  child: Image.asset(

                    isNurse
                        ? "assets/images/nurs.png"
                        : "assets/images/student.png",

                    width: 85,
                    height: 85,
                  ),
                ),

                const SizedBox(height: 3),

                /// NAME
                Text(

                  user.name,

                  style: TextStyle(
                    fontSize: 12,

                    fontWeight:
                    FontWeight.w600,

                    decoration:
                    user.isDeleted
                        ? TextDecoration
                        .lineThrough
                        : null,
                  ),
                ),

                /// ROLE
                Text(
                  user.role,
                  style:
                  const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          /// ================= ALERT BADGE =================
          if (user.alerts.isNotEmpty)
            Positioned(
              top: 5,
              left: 5,

              child:
              TweenAnimationBuilder(

                tween: Tween(
                  begin: -0.08,
                  end: 0.08,
                ),

                duration:
                const Duration(
                  milliseconds: 700,
                ),

                curve:
                Curves.easeInOut,

                builder:
                    (context,
                    value,
                    child) {

                  return Transform.rotate(
                    angle:
                    value as double,

                    child: child,
                  );
                },

                child: Container(

                  padding:
                  const EdgeInsets
                      .all(6),

                  decoration:
                  BoxDecoration(

                    color: Colors.red,

                    shape:
                    BoxShape.circle,

                    boxShadow: [

                      BoxShadow(
                        color: Colors.red
                            .withOpacity(
                          0.4,
                        ),

                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Text(

                    "${user.alerts.length}",

                    style:
                    const TextStyle(
                      color:
                      Colors.white,

                      fontSize: 10,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          /// ================= RESTORE BUTTON =================
          if (user.isDeleted)
            Positioned(
              top: 0,
              right: 5,

              child: GestureDetector(

                onTap: () {
                  c.restoreUser(user);
                },

                child: Container(

                  padding:
                  const EdgeInsets
                      .all(4),

                  decoration:
                  const BoxDecoration(
                    color: Colors.red,
                    shape:
                    BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.close,

                    size: 12,

                    color:
                    Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// =======================================================
  /// DETAILS
  /// =======================================================

  /// ===============================================================
  /// PROFESSIONAL USER DETAILS UI
  /// Replace ONLY _showDetails() method
  /// ===============================================================

  void _showDetails(
      BuildContext context,
      User user,
      ) {

    final tabController =
    TabController(
      length: 4,
      vsync: Navigator.of(context),
    );

    Get.bottomSheet(

      isScrollControlled: true,

      Container(

        height:
        MediaQuery.of(context)
            .size
            .height *
            0.88,


        decoration:
        const BoxDecoration(

          gradient: LinearGradient(
            colors: [
              Color(0xFFF5F3FF),
              Color(0xFFEDE7F6),
 main
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),


          borderRadius:
          BorderRadius.vertical(
main
            top: Radius.circular(35),
          ),
        ),

        child: Column(
          children: [

            const SizedBox(height: 12),

            /// ===================================================
            /// HANDLE
            /// ===================================================

            Container(
              width: 70,
              height: 5,

              decoration: BoxDecoration(
                color: Colors.grey.shade400,

                borderRadius:
                BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),


            /// ===================================================
            /// HEADER
            /// ===================================================

 main
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                children: [

                  /// IMAGE
                  TweenAnimationBuilder(

                    tween: Tween(
                      begin: 0.8,
                      end: 1.0,
                    ),

                    duration:
                    const Duration(
                      milliseconds: 700,
                    ),

                    curve:
                    Curves.elasticOut,

                    builder:
                        (context,
                        value,
                        child) {

                      return Transform.scale(
                        scale:
                        value as double,

                        child: child,
                      );
                    },

                    child: Container(

                      decoration:
                      BoxDecoration(

                        shape:
                        BoxShape.circle,

                        boxShadow: [

                          BoxShadow(
                            color: Colors
                                .deepPurple
                                .withOpacity(
                              0.25,
                            ),

                            blurRadius: 20,
                          ),
                        ],
                      ),

                      child: ClipRRect(

                        borderRadius:
                        BorderRadius
                            .circular(
                          50,
                        ),

                        child: Image.asset(

                          user.role ==
                              "Nurse"


                              ? "assets/images/nurs.png"
                              : "assets/images/student.png",

                          width: 90,
                          height: 90,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  /// INFO
                  Expanded(
                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          user.name,

                          style:
                          const TextStyle(
                            fontSize: 22,

                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

main
                        Text(

                          user.role,

                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade700,

                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Row(
                          children: [

                            _statusChip(
                              user.isActive
                                  ? "Active"
                                  : "Inactive",

                              user.isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            if (user
                                .alerts
                                .isNotEmpty)

                              _statusChip(
                                "${user.alerts.length} Alerts",

                                Colors.orange,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            /// ===================================================
            /// TAB BAR
            /// ===================================================
 main

            Container(

              margin:
              const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              padding:
              const EdgeInsets.all(5),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),

              child: TabBar(

                controller:
                tabController,

                labelColor:
                Colors.white,

                unselectedLabelColor:
                Colors.deepPurple,

                indicator: BoxDecoration(

                  color:
                  Colors.deepPurple,

                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),

                tabs: const [

                  Tab(text: "Overview"),

                  Tab(text: "Alerts"),

                  Tab(text: "Activity"),

                  Tab(text: "Actions"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// ===================================================
            /// TAB VIEW
            /// ===================================================

            Expanded(

              child: TabBarView(

                controller:
                tabController,

                children: [

                  /// =================================================
                  /// OVERVIEW
                  /// =================================================

                  SingleChildScrollView(

                    padding:
                    const EdgeInsets.all(18),

                    child: Column(
                      children: [

                        _glassInfo(
                          "Graduation Year",
                          "${user.graduationYear}",
                          Icons.calendar_month,
                        ),

                        _glassInfo(
                          "Graduation Place",
                          user.graduationPlace,
                          Icons.location_on,
                        ),

                        _glassInfo(
                          "Graduation Date",
                          user.graduationDate,
                          Icons.date_range,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Row(
                          children: [

                            Expanded(
                              child: _statCard(
                                "Warnings",
                                user.warnings,
                                Colors.red,
                                Icons.warning,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            Expanded(
                              child: _statCard(
                                "Bonuses",
                                user.bonuses,
                                Colors.green,
                                Icons.star,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// =================================================
                  /// ALERTS
                  /// =================================================

                  Column(
                    children: [

                      const SizedBox(
                        height: 10,
                      ),

                      Expanded(

                        child:
                        user.alerts.isEmpty

                            ? Center(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                            children: [

                              TweenAnimationBuilder(

                                tween: Tween(
                                  begin: 0.9,
                                  end: 1.05,
                                ),

                                duration:
                                const Duration(
                                  milliseconds:
                                  800,
                                ),

                                curve: Curves
                                    .easeInOut,

                                builder:
                                    (context,
                                    value,
                                    child) {

                                  return Transform
                                      .scale(
                                    scale:
                                    value as double,

                                    child: child,
                                  );
                                },

                                child: Icon(
                                  Icons
                                      .notifications_none,

                                  size: 90,

                                  color: Colors
                                      .grey
                                      .shade400,
                                ),
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              Text(

                                "No alerts yet",

                                style: TextStyle(
                                  fontSize: 16,

                                  color: Colors
                                      .grey
                                      .shade700,
                                ),
                              ),
                            ],
                          ),
                        )

                            : ListView.builder(

                          padding:
                          const EdgeInsets
                              .all(18),

                          itemCount:
                          user.alerts
                              .length,

                          itemBuilder:
                              (context,
                              index) {

                            final alert =
                            user.alerts[
                            index];

                            Color color =
                                Colors.blue;

                            if (alert.priority ==
                                "High") {
                              color =
                                  Colors.red;
                            }

                            if (alert.priority ==
                                "Critical") {
                              color =
                                  Colors.purple;
                            }

                            return Container(

                              margin:
                              const EdgeInsets
                                  .only(
                                bottom:
                                14,
                              ),

                              padding:
                              const EdgeInsets
                                  .all(
                                16,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.white,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  20,
                                ),

                                boxShadow: [

                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.05,
                                    ),

                                    blurRadius:
                                    12,
                                  ),
                                ],
                              ),

                              child: Row(

                                children: [

                                  Container(

                                    padding:
                                    const EdgeInsets
                                        .all(
                                      10,
                                    ),

                                    decoration:
                                    BoxDecoration(

                                      color:
                                      color.withOpacity(
                                        0.12,
                                      ),

                                      shape:
                                      BoxShape
                                          .circle,
                                    ),

                                    child: Icon(
                                      Icons
                                          .notifications_active,

                                      color:
                                      color,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(
                                    child:
                                    Column(

                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                      children: [

                                        Text(

                                          alert.title,

                                          style:
                                          const TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,

                                            fontSize:
                                            15,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                          4,
                                        ),

                                        Text(
                                          alert.message,
                                        ),

                                        const SizedBox(
                                          height:
                                          6,
                                        ),

                                        Text(

                                          alert.priority,

                                          style:
                                          TextStyle(
                                            color:
                                            color,

                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets
                            .all(18),

                        child: SizedBox(

                          width:
                          double.infinity,

                          child:
                          ElevatedButton.icon(

                            style:
                            ElevatedButton
                                .styleFrom(

                              backgroundColor:
                              Colors.orange,

                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical:
                                15,
                              ),

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  18,
                                ),
                              ),
                            ),

                            onPressed: () {

                              Get.back();

                              _showAlertDialog(
                                user,
                              );
                            },

                            icon: const Icon(
                              Icons.add_alert,
                              color:
                              Colors.white,
                            ),

                            label: const Text(
                              "Send Alert",

                              style:
                              TextStyle(
                                color: Colors
                                    .white,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// =================================================
                  /// ACTIVITY
                  /// =================================================

                  ListView.builder(

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    itemCount:
                    user.activityLog
                        .length,

                    itemBuilder:
                        (context, index) {

                      return Row(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Column(
                            children: [

                              Container(
                                width: 14,
                                height: 14,

                                decoration:
                                const BoxDecoration(
                                  color: Colors
                                      .deepPurple,

                                  shape: BoxShape
                                      .circle,
                                ),
                              ),

                              if (index !=
                                  user.activityLog
                                      .length -
                                      1)

                                Container(
                                  width: 2,
                                  height: 60,
                                  color: Colors
                                      .deepPurple
                                      .withOpacity(
                                    0.3,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Container(

                              margin:
                              const EdgeInsets
                                  .only(
                                bottom:
                                20,
                              ),

                              padding:
                              const EdgeInsets
                                  .all(
                                14,
                              ),

                              decoration:
                              BoxDecoration(


                                color:
                                Colors.white,
 main

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  16,
                                ),
                              ),

                              child: Text(

                                user.activityLog[
                                index],
 main
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  /// =================================================
                  /// ACTIONS
                  /// =================================================

                  Padding(

                    padding:
                    const EdgeInsets.all(
                      20,
                    ),

                    child: Column(
                      children: [

                        _actionButton(

                          title: "Edit User",

                          icon: Icons.edit,

                          color:
                          Colors.deepPurple,

                          onTap: () {

                            Get.back();

                            _showForm(
                              context,
                              user: user,
                            );
                          },
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        _actionButton(

                          title:
                          user.isDeleted
                              ? "Restore User"
                              : "Delete User",

                          icon:
                          user.isDeleted
                              ? Icons.restore
                              : Icons.delete,

                          color:
                          user.isDeleted
                              ? Colors.green
                              : Colors.red,

                          onTap: () {

                            if (user
                                .isDeleted) {

                              c.restoreUser(
                                user,
                              );

                            } else {

                              c.softDelete(
                                user,
                              );
                            }

                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================================================
  /// STATUS CHIP
  /// ===============================================================

  Widget _statusChip(
      String text,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(

        color:
        color.withOpacity(0.12),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(

        text,

        style: TextStyle(
          color: color,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  /// ===============================================================
  /// GLASS INFO CARD
  /// ===============================================================

  Widget _glassInfo(
      String title,
      String value,
      IconData icon,
      ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.deepPurple,
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
                    Colors.grey.shade700,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(

                  value,

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================================================
  /// STAT CARD
  /// ===============================================================

  Widget _statCard(
      String title,
      int value,
      Color color,
      IconData icon,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        children: [

          Container(

            padding:
            const EdgeInsets.all(10),

            decoration: BoxDecoration(

              color:
              color.withOpacity(0.1),

              shape:
              BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            "$value",

            style: TextStyle(

              fontSize: 22,

              fontWeight:
              FontWeight.bold,

              color: color,
            ),
          ),

          const SizedBox(height: 4),

          Text(title),
        ],
      ),
    );
  }

  /// ===============================================================
  /// ACTION BUTTON
  /// ===============================================================

  Widget _actionButton({

    required String title,

    required IconData icon,

    required Color color,

    required VoidCallback onTap,
  }) {

    return SizedBox(

      width: double.infinity,

      child: ElevatedButton.icon(

        style:
        ElevatedButton.styleFrom(

          backgroundColor: color,

          padding:
          const EdgeInsets.symmetric(
            vertical: 10,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),
        ),

        onPressed: onTap,

        icon: Icon(
          icon,
          color: Colors.white,
        ),

        label: Text(

          title,

          style: const TextStyle(
            color: Colors.white,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// =======================================================
  /// SEND ALERT DIALOG
  /// =======================================================

  void _showAlertDialog(User user) {
    final title = TextEditingController();
    final message = TextEditingController();
    final priority = "High".obs;

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300, // نفس فورم التعديل
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFFE0B2),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 40,
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Send Alert",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _field(
                    "Title",
                    title,
                  ),

                  _field(
                    "Message",
                    message,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 6),

                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: priority.value,
                      items: ["Low", "Medium", "High", "Critical"]
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (v) => priority.value = v!,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        labelText: "Priority",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 34,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        c.sendAlert(
                          user,
                          UserAlert(
                            title: title.text,
                            message: message.text,
                            priority: priority.value,
                            createdAt: DateTime.now(),
                          ),
                        );

                        Get.back();
                      },
                      child: const Text(
                        "SEND",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _showForm(
      BuildContext context,
      {User? user}
      ) {

    final name =
    TextEditingController(
      text: user?.name ?? '',
    );

    final role =
    TextEditingController(
      text: user?.role ?? '',
    );

    final year =
    TextEditingController(
      text: user?.graduationYear
          .toString() ??
          '',
    );

    final place =
    TextEditingController(
      text:
      user?.graduationPlace ?? '',
    );

    final date =
    TextEditingController(
      text:
      user?.graduationDate ?? '',
    );

    final warnings =
    TextEditingController(
      text:
      user?.warnings.toString() ??
          '0',
    );

    final bonuses =
    TextEditingController(
      text:
      user?.bonuses.toString() ??
          '0',
    );

    final isEdit =
        user != null;
    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,

      Material(
        color: Colors.black54, // خلفية داكنة

        child: Center(
          child: Container(
            width: 300, // 🔥 هذا أهم شيء
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFFE0B2),
                ],
              ),
 main
              borderRadius: BorderRadius.circular(18),
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // 🔥 مهم جداً
                children: [

                  Text(

                    isEdit
                        ? "Edit User"
                        : "Add New User",

                    style:
                    const TextStyle(
                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  _field(
                    "Name",
                    name,
                  ),

                  _field(
                    "Role",
                    role,
                  ),

                  _field(
                    "Graduation Year",
                    year,
                  ),

                  _field(
                    "Graduation Place",
                    place,
                  ),

                  _field(
                    "Graduation Date",
                    date,
                  ),

                  Row(
                    children: [

                      Expanded(
                        child: _field(
                          "Warnings",
                          warnings,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: _field(
                          "Bonuses",
                          bonuses,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  SizedBox(
                    width:
                    double.infinity,

                    height: 45,

                    child:
                    ElevatedButton(

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        Colors
                            .deepPurple,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            15,
                          ),
                        ),
                      ),

                      onPressed: () {

                        final newUser =
                        User(

                          name:
                          name.text,

                          role:
                          role.text,

                          graduationYear:
                          int.tryParse(
                            year.text,
                          ) ??
                              0,

                          graduationPlace:
                          place.text,

                          graduationDate:
                          date.text,

                          warnings:
                          int.tryParse(
                            warnings
                                .text,
                          ) ??
                              0,

                          bonuses:
                          int.tryParse(
                            bonuses
                                .text,
                          ) ??
                              0,

                          activityLog:
                          user
                              ?.activityLog ??
                              [],

                          alerts:
                          user
                              ?.alerts ??
                              [],
                        );

                        if (isEdit) {

                          final index =
                          c.users.indexOf(
                            user!,
                          );

                          c.updateUser(
                            index,
                            newUser,
                          );

                        } else {

                          c.addUser(
                            newUser,
                          );
                        }

                        Get.back();
                      },

                      child:
                      const Text(

                        "SAVE",

                        style:
                        TextStyle(
                          color: Colors
                              .white,

                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// =======================================================
  /// FIELD
  /// =======================================================

  Widget _field(
      String hint,
      TextEditingController c, {
        int maxLines = 1,
        bool compact = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          isDense: compact, // 👈 أهم نقطة
          contentPadding: compact
              ? const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          )
              : const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
          labelText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}