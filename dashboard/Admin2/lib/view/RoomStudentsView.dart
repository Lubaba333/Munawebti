import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controller/CurrentRoomController.dart';
import '../controller/RoomHistoryController.dart';

import '../controller/RoomLogsController.dart';
import '../controller/RoomStudentsController.dart';

import '../model/RoomModel.dart';
import '../model/RoomStudentModel.dart';



import '../widgets/AppColors.dart';
import 'ComplaintsView.dart';

class RoomDetailsView extends StatelessWidget {
  RoomDetailsView({super.key});

  final RoomStudentsController studentsController =
  Get.put(RoomStudentsController());

  @override
  Widget build(BuildContext context) {

    final RoomModel room = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentsController.fetchStudents(room.id);
    });

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          boxShadow: [

            BoxShadow(
              color: AppColors.primary
                  .withOpacity(.35),

              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),

        child: FloatingActionButton(
          elevation: 0,

          backgroundColor: AppColors.primary,

          onPressed: () {
            _assignStudentDialog(
              room.id,
              studentsController,
            );
          },

          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),

      body: Column(
        children: [

          // =====================================================
          // HEADER
          // =====================================================
          Stack(
            children: [

              Container(
                height: 290,

                decoration: const BoxDecoration(
                  gradient:
                  AppColors.primaryGradient,

                  borderRadius:
                  BorderRadius.only(
                    bottomLeft:
                    Radius.circular(45),

                    bottomRight:
                    Radius.circular(45),
                  ),
                ),
              ),

              // ================= GLOW LEFT =================
              Positioned(
                top: -60,
                left: -40,

                child: Container(
                  width: 180,
                  height: 180,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.white
                        .withOpacity(.12),
                  ),
                ),
              ),

              // ================= GLOW RIGHT =================
              Positioned(
                top: 50,
                right: -30,

                child: Container(
                  width: 140,
                  height: 140,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.white
                        .withOpacity(.08),
                  ),
                ),
              ),

              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 90,
                  sigmaY: 90,
                ),

                child: Container(
                  height: 290,
                  color: Colors.transparent,
                ),
              ),

              SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // ================= TOP =================
                      Row(
                        children: [

                          _glassButton(
                            icon: Icons
                                .arrow_back_ios_new,

                            onTap: () {
                              Get.back();
                            },
                          ),

                          const Spacer(),

                          _glassButton(
                            icon: Icons.history,

                            onTap: () {
                              _showRoomHistory(
                                  room.id);
                            },
                          ),

                          const SizedBox(width: 12),

                          _glassButton(
                            icon: Icons
                                .report_problem_rounded,

                            onTap: () {
                              Get.to(() =>
                                  ComplaintsView());
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 45),

                      // ================= TITLE =================
                      Text(
                        "Room ${room.roomNumber}",

                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 38,

                          fontWeight:
                          FontWeight.w900,

                          letterSpacing: -1,
                        ),
                      )
                          .animate()
                          .fadeIn(
                        duration: 500.ms,
                      )
                          .slideY(
                        begin: .3,
                        end: 0,
                      ),

                      const SizedBox(height: 12),

                      Obx(() {
                        return Text(
                          "${studentsController.students.length} Students",

                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(.8),

                            fontSize: 17,
                          ),
                        )
                            .animate()
                            .fadeIn(
                          delay: 200.ms,
                          duration: 500.ms,
                        );
                      }),

                      const SizedBox(height: 28),

                      // ================= STATS =================
                      Row(
                        children: [

                          Expanded(
                            child: _statCard(
                              title: "Students",

                              value:
                              "${studentsController.students.length}",

                              icon:
                              Icons.people_alt,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: _statCard(
                              title: "Room ID",

                              value: "${room.id}",

                              icon:
                              Icons.meeting_room,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // BODY
          // =====================================================
          Expanded(
            child: Obx(() {

              // ================= LOADING =================
              if (studentsController
                  .isLoading.value) {

                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              // ================= EMPTY =================
              if (studentsController
                  .students.isEmpty) {

                return Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.people_outline,
                        size: 90,

                        color: AppColors.primary
                            .withOpacity(.5),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "لا يوجد طلاب داخل الغرفة",

                        style: TextStyle(
                          fontSize: 18,

                          color:
                          AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // ================= LIST =================
              return ListView.builder(
                padding:
                const EdgeInsets.all(20),

                itemCount:
                studentsController
                    .students.length,

                itemBuilder:
                    (context, index) {

                  final RoomStudentModel
                  student =
                  studentsController
                      .students[index];

                  return TweenAnimationBuilder(
                    duration: Duration(
                      milliseconds:
                      400 + (index * 120),
                    ),

                    tween: Tween<double>(
                      begin: .8,
                      end: 1,
                    ),

                    curve:
                    Curves.easeOutBack,

                    builder:
                        (context, value, child) {

                      return Transform.scale(
                        scale: value,

                        child: Opacity(
                          opacity: value,

                          child: child,
                        ),
                      );
                    },

                    child: GestureDetector(
                      onTap: () {
                        _showStudentHistory(
                          student.id,
                          student.name,
                        );
                      },

                      child: Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 18,
                        ),

                        decoration:
                        BoxDecoration(
                          gradient:
                          AppColors
                              .cardGradient,

                          borderRadius:
                          BorderRadius
                              .circular(30),

                          boxShadow: [

                            BoxShadow(
                              color: AppColors
                                  .primary
                                  .withOpacity(
                                  .08),

                              blurRadius: 25,

                              offset:
                              const Offset(
                                  0, 10),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding:
                          const EdgeInsets
                              .all(18),

                          child: Row(
                            children: [

                              // ================= AVATAR =================
                              Hero(
                                tag: student.id,

                                child: Container(
                                  width: 65,
                                  height: 65,

                                  decoration:
                                  BoxDecoration(
                                    gradient:
                                    AppColors
                                        .primaryGradient,

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        24),

                                    boxShadow: [

                                      BoxShadow(
                                        color: AppColors
                                            .secondary
                                            .withOpacity(
                                            .35),

                                        blurRadius:
                                        25,
                                      ),
                                    ],
                                  ),

                                  child: Center(
                                    child: Text(
                                      student.name
                                          .isNotEmpty
                                          ? student
                                          .name[
                                      0]
                                          : "?",

                                      style:
                                      const TextStyle(
                                        color: Colors
                                            .white,

                                        fontSize:
                                        24,

                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width: 18),

                              // ================= INFO =================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  children: [

                                    Text(
                                      student.name,

                                      style:
                                      const TextStyle(
                                        fontSize:
                                        18,

                                        fontWeight:
                                        FontWeight
                                            .bold,

                                        color: AppColors
                                            .darkText,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 8),

                                    Text(
                                      student.email,

                                      style:
                                      TextStyle(
                                        color:
                                        AppColors
                                            .grey,

                                        fontSize:
                                        14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ================= ACTIONS =================
                              Row(
                                children: [

                                  _actionButton(
                                    icon: Icons
                                        .visibility_rounded,

                                    color: AppColors
                                        .primary,

                                    onTap: () {
                                      _showCurrentRoom(
                                        student.id,
                                        student
                                            .name,
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  _actionButton(
                                    icon: Icons
                                        .delete_rounded,

                                    color: Colors
                                        .redAccent,

                                    onTap: () {
                                      studentsController
                                          .removeStudent(
                                        roomId:
                                        room.id,

                                        studentId:
                                        student
                                            .id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GLASS BUTTON
  // =========================================================
  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(18),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),

          child: Container(
            padding:
            const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(.12),

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color:
                Colors.white.withOpacity(
                    .15),
              ),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ACTION BUTTON
  // =========================================================
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding:
        const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: color.withOpacity(.1),

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [

            BoxShadow(
              color: color.withOpacity(.2),

              blurRadius: 20,
            ),
          ],
        ),

        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  // =========================================================
  // STAT CARD
  // =========================================================
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return ClipRRect(
      borderRadius:
      BorderRadius.circular(26),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),

        child: Container(
          padding:
          const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color:
            Colors.white.withOpacity(.12),

            borderRadius:
            BorderRadius.circular(26),

            border: Border.all(
              color:
              Colors.white.withOpacity(.1),
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Icon(
                icon,
                color: Colors.white,
              ),

              const SizedBox(height: 15),

              Text(
                value,

                style: const TextStyle(
                  color: Colors.white,

                  fontSize: 22,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,

                style: TextStyle(
                  color: Colors.white
                      .withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // ROOM HISTORY
  // =========================================================
  void _showRoomHistory(int roomId) {

    final RoomHistoryController controller =
    Get.put(RoomHistoryController());

    controller.fetchHistory(roomId);

    Get.bottomSheet(
      _sheetContainer(
        child: Obx(() {

          if (controller.isLoading.value) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount:
            controller.history.length,

            itemBuilder: (context, index) {

              final item =
              controller.history[index];

              return _historyTile(
                title: item.studentName,

                subtitle: item.date,

                assigned:
                item.action ==
                    "assigned",
              );
            },
          );
        }),
      ),

      isScrollControlled: true,
    );
  }

  // =========================================================
  // STUDENT HISTORY
  // =========================================================
  void _showStudentHistory(
      int studentId,
      String studentName,
      ) {

    final StudentHistoryController
    controller =
    Get.put(
        StudentHistoryController());

    controller.fetchStudentHistory(
        studentId);

    Get.bottomSheet(
      _sheetContainer(
        child: Obx(() {

          if (controller.isLoading.value) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount:
            controller.history.length,

            itemBuilder: (context, index) {

              final item =
              controller.history[index];

              return _historyTile(
                title:
                "Room ${item.roomNumber}",

                subtitle: item.date,

                assigned:
                item.action ==
                    "assigned",
              );
            },
          );
        }),
      ),

      isScrollControlled: true,
    );
  }

  // =========================================================
  // CURRENT ROOM
  // =========================================================
  void _showCurrentRoom(
      int studentId,
      String name,
      ) {

    final CurrentRoomController
    controller =
    Get.put(CurrentRoomController());

    controller.fetchCurrentRoom(
        studentId);

    Get.bottomSheet(
      _sheetContainer(
        child: Obx(() {

          if (controller.isLoading.value) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final room =
              controller.currentRoom.value;

          if (room == null) {
            return const Center(
              child: Text(
                "الطالب غير موجود حالياً",
              ),
            );
          }

          return Container(
            padding:
            const EdgeInsets.all(22),

            decoration: BoxDecoration(
              gradient:
              AppColors.cardGradient,

              borderRadius:
              BorderRadius.circular(30),
            ),

            child: ListTile(
              leading: Container(
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  gradient: AppColors
                      .primaryGradient,

                  borderRadius:
                  BorderRadius.circular(
                      18),
                ),

                child: const Icon(
                  Icons.meeting_room,
                  color: Colors.white,
                ),
              ),

              title: Text(
                "Room ${room.roomNumber}",
              ),

              subtitle: Text(
                "Assigned at: ${room.assignedAt}",
              ),
            ),
          );
        }),
      ),
    );
  }

  // =========================================================
  // ADD STUDENT
  // =========================================================
  void _assignStudentDialog(
      int roomId,
      RoomStudentsController
      controller,
      ) {

    final TextEditingController
    studentIdController =
    TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor:
        Colors.transparent,

        child: Container(
          padding:
          const EdgeInsets.all(25),

          decoration: BoxDecoration(
            gradient:
            AppColors.cardGradient,

            borderRadius:
            BorderRadius.circular(35),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              const Text(
                "إضافة طالب",

                style: TextStyle(
                  fontSize: 24,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller:
                studentIdController,

                keyboardType:
                TextInputType.number,

                decoration:
                InputDecoration(
                  hintText: "Student ID",

                  filled: true,

                  fillColor:
                  AppColors.background,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius
                        .circular(18),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style:
                  ElevatedButton
                      .styleFrom(
                    elevation: 0,

                    backgroundColor:
                    AppColors
                        .primary,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          18),
                    ),
                  ),

                  onPressed: () {

                    if (studentIdController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    controller.assignStudent(
                      roomId: roomId,

                      studentId: int.parse(
                        studentIdController
                            .text,
                      ),
                    );

                    Get.back();
                  },

                  child: const Text(
                    "إضافة",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SHEET CONTAINER
  // =========================================================
  Widget _sheetContainer({
    required Widget child,
  }) {
    return Container(
      height: 600,

      padding:
      const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),

      child: child,
    );
  }

  // =========================================================
  // HISTORY TILE
  // =========================================================
  Widget _historyTile({
    required String title,
    required String subtitle,
    required bool assigned,
  }) {
    return Container(
      margin:
      const EdgeInsets.only(bottom: 16),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient:
        AppColors.cardGradient,

        borderRadius:
        BorderRadius.circular(28),

        boxShadow: [

          BoxShadow(
            color: AppColors.primary
                .withOpacity(.06),

            blurRadius: 18,
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            width: 55,
            height: 55,

            decoration: BoxDecoration(
              color: assigned
                  ? Colors.green
                  .withOpacity(.12)
                  : Colors.red
                  .withOpacity(.12),

              borderRadius:
              BorderRadius.circular(
                  18),
            ),

            child: Icon(
              assigned
                  ? Icons.login
                  : Icons.logout,

              color: assigned
                  ? Colors.green
                  : Colors.redAccent,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}