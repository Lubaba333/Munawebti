import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/HousingController.dart';
import '../widgets/AppColors.dart';

// ================== BUILDINGS SCREEN ==================
class BuildingsScreen extends StatelessWidget {
  BuildingsScreen({super.key});

  final HousingController c = Get.find();

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white, // 👈 هنا نخلي زر الرجوع أبيض
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Housing Units",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (c.buildings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: c.buildings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final b = c.buildings[index];

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 400 + (index * 80)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: Transform.translate(
                      offset: Offset(0, 40 * (1 - value)),
                      child: child,
                    ),
                  ),
                );
              },
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/rooms',
                    arguments: b,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: "building_${b.id}",
                          child: Image.asset(
                            b.imageUrl ?? "assets/images/default.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            b.name ?? "No Name",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ================== ROOMS SCREEN ==================
class RoomsScreen extends StatelessWidget {
  final Building building;

  RoomsScreen({super.key, required this.building});

  final HousingController c = Get.find();

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white, // 👈 هنا نخلي زر الرجوع أبيض
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                building.name ?? "",
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _filter("All", "all"),
              _filter("Empty", "empty"),
              _filter("Full", "full"),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              final rooms =
              c.getFilteredRooms(building.rooms ?? []);

              if (rooms.isEmpty) {
                return const Center(child: Text("No rooms"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: rooms.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, i) {
                  final r = rooms[i];

                  final ratio =
                  r.capacity == 0 ? 0 : r.users.length / r.capacity;

                  Color border = r.isFull
                      ? Colors.red
                      : (ratio > 0.5 ? Colors.orange : Colors.green);

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (i * 60)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => Get.toNamed(
                        '/roomDetails',
                        arguments: r,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: "room_${r.id}",
                                child: Image.asset(
                                  r.imageUrl ??
                                      "assets/images/default.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: border, width: 2),
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),

                            Positioned(
                              bottom: 5,
                              left: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                  Colors.black.withOpacity(0.4),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      r.name ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${r.users.length}/${r.capacity}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  Widget _filter(String text, String value) {
    return Obx(() {
      final selected = c.selectedFilter.value == value;

      return GestureDetector(
        onTap: () => c.selectedFilter.value = value,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF5A0891)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    });
  }
}

// ================== ROOM DETAILS =================
class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  RoomDetailsScreen({super.key, required this.room});

  final HousingController controller = Get.find();

  final TextEditingController studentController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  @override
  Widget build(BuildContext context) {
    capacityController.text = room.capacity.toString();
    notesController.text = room.notes;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APP BAR =================
      appBar:
      PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.white, // 👈 هنا نخلي زر الرجوع أبيض
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                room.name,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= IMAGE =================
            Image.asset(
              room.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 15),

            // ================= CAPACITY =================
            _card(
              icon: Icons.meeting_room,
              title: "Capacity",
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        hintText: "Capacity",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      controller.updateCapacity(
                        room,
                        int.parse(capacityController.text),
                      );
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),

            // ================= ADD STUDENT =================
            _card(
              icon: Icons.person_add,
              title: "Add Student",
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: studentController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Student name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (studentController.text.isNotEmpty) {
                        controller.addStudent(
                          room,
                          studentController.text,
                        );
                        studentController.clear();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),

            // ================= NOTES =================
            _card(
              icon: Icons.note_alt,
              title: "Notes",
              child: Column(
                children: [
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.edit),
                      hintText: "Write notes...",
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      controller.updateNotes(
                        room,
                        notesController.text,
                      );
                    },
                    child: const Text("Save Notes"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ================= STUDENTS DROPDOWN =================
            _card(
              icon: Icons.group,
              title: "Students (${room.users.length})",
              child: room.users.isEmpty
                  ? const Text(
                "No students",
                style: TextStyle(color: AppColors.grey),
              )
                  : ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding:
                const EdgeInsets.symmetric(horizontal: 8),

                title: const Text(
                  "Show Students",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                children: room.users.map((student) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          student[0].toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                      ),
                      title: Text(student),

                      // ================= ACTIONS =================
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // 🔁 MOVE
                          IconButton(
                            icon: const Icon(Icons.swap_horiz,
                                color: Colors.blue),
                            onPressed: () {
                              _showMoveDialog(student);
                            },
                          ),

                          // 🗑 DELETE
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              controller.removeStudent(
                                  room, student);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= MOVE DIALOG =================
  void _showMoveDialog(String student) {
    Get.defaultDialog(
      title: "Move Student",
      content: Column(
        children: controller.buildings
            .expand((b) => b.rooms)
            .map((r) {
          return ListTile(
            title: Text(r.name),
            subtitle:
            Text("${r.users.length}/${r.capacity}"),
            onTap: () {
              controller.moveStudent(
                from: room,
                to: r,
                student: student,
              );
              Get.back();
            },
          );
        }).toList(),
      ),
    );
  }

  // ================= CARD =================
  Widget _card({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
// ================== ADVANCED TRANSITION ==================
class AdvancedDoorTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );

    return AnimatedBuilder(
      animation: curved,
      child: child,
      builder: (context, child) {
        final angle = (1 - curved.value) * 1.1;

        return Opacity(
          opacity: curved.value,
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle)
              ..scale(0.9 + (curved.value * 0.1)),
            child: child,
          ),
        );
      },
    );
  }
}