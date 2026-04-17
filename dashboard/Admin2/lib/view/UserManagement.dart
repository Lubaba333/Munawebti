import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/UserManagement_controller.dart';
import '../widgets/AppColors.dart';

class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});

  final c = Get.put(UserManagementController());

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
  );
  final List<String> filters = [
    "All",
    "Nurses",
    "Students",
    "Deleted" // 👈 جديد
  ];
  final RxInt animationKey = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "User Management",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// FILTER
          _buildFilters(),

          const SizedBox(height: 10),

          /// GRID
          Expanded(
            child: Obx(() {
              final list = c.filteredUsers;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: GridView.builder(
                  key: ValueKey(animationKey.value),
                  padding: const EdgeInsets.all(6),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return _animatedUser(context, list[i], i);
                  },
                ),
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showForm(context),
      ),
    );
  }

  // ================= FILTER =================
  Widget _buildFilters() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: filters.map((f) {
          final active = c.filter.value == f;

          return GestureDetector(
            onTap: () {
              c.setFilter(f);
              animationKey.value++;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // ================= ANIMATION =================
  Widget _animatedUser(BuildContext context, User user, int index) {
    final direction = index % 4;

    final Offset startOffset = switch (direction) {
      0 => const Offset(-150, -120),
      1 => const Offset(150, -120),
      2 => const Offset(-150, 120),
      _ => const Offset(150, 120),
    };

    return TweenAnimationBuilder<double>(
      key: ValueKey(user.name + animationKey.value.toString()),
      duration: Duration(milliseconds: 900 + index * 80),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            startOffset.dx * (1 - value),
            startOffset.dy * (1 - value),
          ),
          child: Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.6 + (value * 0.4),
              child: child,
            ),
          ),
        );
      },
      child: _userCard(context, user),
    );
  }

  // ================= CARD =================
  Widget _userCard(BuildContext context, User user) {
    final isNurse = user.role == "Nurse";

    return GestureDetector(
      onTap: user.isDeleted
          ? null
          : () => _showDetails(context, user),

      child: Stack(
        children: [

          /// CARD
          Opacity(
            opacity: user.isDeleted ? 0.4 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    isNurse
                        ? "assets/images/nurs.png"
                        : "assets/images/student.png",
                    width: 85,
                    height: 85,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: user.isDeleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                Text(user.role,
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          ),

          /// ❌ X BUTTON (only for deleted users)
          if (user.isDeleted)
            Positioned(
              top: 0,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  c.restoreUser(user);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================= DETAILS =================
  void _showDetails(BuildContext context, User user) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 👤 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                user.role == "Nurse"
                    ? "assets/images/nurs.png"
                    : "assets/images/student.png",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),

            /// NAME + ROLE
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              user.role,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 12),

            /// 📌 INFO
            _info("Graduation Year", "${user.graduationYear}"),
            _info("Place", user.graduationPlace),
            _info("Date", user.graduationDate),

            const SizedBox(height: 10),

            /// 📊 STATS
            Row(
              children: [
                Expanded(child: _mini("Warnings", user.warnings, Colors.red)),
                const SizedBox(width: 10),
                Expanded(child: _mini("Bonuses", user.bonuses, Colors.green)),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔘 ACTIONS
            Row(
              children: [

                /// ✔ DELETE / RESTORE
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      user.isDeleted ? Colors.green : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (user.isDeleted) {
                        c.restoreUser(user);
                      } else {
                        c.softDelete(user);
                      }
                      Get.back();
                    },
                    child: Text(
                      user.isDeleted ? "Restore" : "Delete",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// ✔ EDIT (ONLY IF NOT DELETED)
                if (!user.isDeleted)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        _showForm(context, user: user);
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= INFO =================
  Widget _info(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Widget _mini(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text("$value",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color)),
          Text(title),
        ],
      ),
    );
  }

  // ================= FORM =================
  void _showForm(BuildContext context, {User? user}) {
    final name = TextEditingController(text: user?.name ?? '');
    final role = TextEditingController(text: user?.role ?? '');

    final year =
    TextEditingController(text: user?.graduationYear.toString() ?? '');
    final place =
    TextEditingController(text: user?.graduationPlace ?? '');
    final date =
    TextEditingController(text: user?.graduationDate ?? '');

    final warnings =
    TextEditingController(text: user?.warnings.toString() ?? '0');
    final bonuses =
    TextEditingController(text: user?.bonuses.toString() ?? '0');

    final isEdit = user != null;

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 360,
            constraints: const BoxConstraints(maxHeight: 650),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF3E5F5),
                  Color(0xFFEDE7F6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// TITLE
                  Text(
                    isEdit ? "Edit User " : "Add New User ➕",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// SECTION 1
                  _sectionTitle("Basic Info"),

                  _field("Name", name),
                  _field("Role (Nurse / Student)", role),

                  const SizedBox(height: 10),

                  /// SECTION 2
                  _sectionTitle("Graduation Info"),

                  _field("Graduation Year", year),
                  _field("Graduation Place", place),
                  _field("Graduation Date", date),

                  const SizedBox(height: 10),

                  /// SECTION 3
                  _sectionTitle("Performance"),

                  Row(
                    children: [
                      Expanded(child: _field("Warnings", warnings)),
                      const SizedBox(width: 10),
                      Expanded(child: _field("Bonuses", bonuses)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        final newUser = User(
                          name: name.text,
                          role: role.text,
                          graduationYear: int.tryParse(year.text) ?? 0,
                          graduationPlace: place.text,
                          graduationDate: date.text,
                          warnings: int.tryParse(warnings.text) ?? 0,
                          bonuses: int.tryParse(bonuses.text) ?? 0,
                          activityLog: user?.activityLog ?? [],
                        );

                        if (isEdit) {
                          final index = c.users.indexOf(user!);
                          c.updateUser(index, newUser);
                        } else {
                          c.addUser(newUser);
                        }

                        Get.back();
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
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
        ),
      ),
    );
  }
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
  Widget _field(String hint, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}