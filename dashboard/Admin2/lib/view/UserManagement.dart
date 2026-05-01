import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/UserManagement_controller.dart';
import '../model/user_model.dart';

class UserManagementScreen extends StatelessWidget {

  UserManagementScreen({super.key});

  final c = Get.put(UserManagementController());

  final Gradient primaryGradient =
  const LinearGradient(
    colors: [
      Color(0xFF5A0891),
      Color(0xFF8E2DE2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final List<String> filters = [
    "Students",
    "Supervisors",
  ];

  /// ================= ANIMATION KEY =================
  final RxInt animationKey = 0.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F3FF),

      /// ================= APP BAR =================
      appBar: PreferredSize(

        preferredSize: const Size.fromHeight(70),

        child: Container(

          decoration: BoxDecoration(
            gradient: primaryGradient,
          ),

          child: AppBar(

            backgroundColor: Colors.transparent,

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

      /// ================= FAB =================
      floatingActionButton: FloatingActionButton(

        backgroundColor: const Color(0xFF8E2DE2),

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        onPressed: () =>
            _showUserForm(context),
      ),

      /// ================= BODY =================
      body: Column(
        children: [

          const SizedBox(height: 12),

          _buildFilters(),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {

              if (c.isLoading.value) {

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return AnimatedSwitcher(

                duration: const Duration(
                  milliseconds: 500,
                ),

                transitionBuilder:
                    (child, animation) {

                  return FadeTransition(

                    opacity: animation,

                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },

                child: GridView.builder(

                  key: ValueKey(
                    animationKey.value,
                  ),

                  padding: const EdgeInsets.all(8),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 5,

                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,

                    childAspectRatio: 0.78,
                  ),

                  itemCount: c.users.length,

                  itemBuilder:
                      (context, i) {

                    return _animatedUser(
                      context,
                      c.users[i],
                      i,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// =======================================================
  /// FILTERS
  /// =======================================================

  Widget _buildFilters() {

    return Obx(() {

      return Row(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: filters.map((f) {

          final active =
              c.filter.value == f;

          return GestureDetector(

            onTap: () {

              c.changeFilter(f);

              animationKey.value++;
            },

            child: AnimatedContainer(

              duration:
              const Duration(milliseconds: 300),

              margin:
              const EdgeInsets.symmetric(
                horizontal: 5,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                gradient:
                active ? primaryGradient : null,

                color:
                active ? null : Colors.white,

                borderRadius:
                BorderRadius.circular(22),

                border: Border.all(
                  color: const Color(0xFF5A0891),
                ),
              ),

              child: Text(

                f,

                style: TextStyle(

                  color:
                  active
                      ? Colors.white
                      : const Color(0xFF5A0891),

                  fontWeight: FontWeight.bold,
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
      UserModel user,
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
        user.id.toString() +
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
      UserModel user,
      ) {
    final isBlocked = user.isBlocked;

    return GestureDetector(
      onTap: () => _showDetails(context, user),

      child: Stack(
        children: [

          /// ================= CARD CONTENT =================
          Opacity(
            opacity: isBlocked ? 0.5 : 1.0, // 🔴 يخلي الكارد رمادي خفيف
            child: ColorFiltered(
              colorFilter: isBlocked
                  ? const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              )
                  : const ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      user.role == "Supervisor"
                          ? "assets/images/nurs.png"
                          : "assets/images/student.png",
                      width: 85,
                      height: 85,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    user.role,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= BLOCK BADGE =================
          if (isBlocked)
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "BLOCKED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          /// ================= EDIT BUTTON =================
          Positioned(
            top: 0,
            right: 5,
            child: GestureDetector(
              onTap: () => _showUserForm(context, user: user),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF8E2DE2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
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

  /// =======================================================
  /// DETAILS
  /// =======================================================

  void _showDetails(BuildContext context, UserModel user) {

    Get.bottomSheet(

      isScrollControlled: true,

      Obx(() {

        final updatedUser =
        c.users.firstWhereOrNull(
                (e) => e.id == user.id);

        if (updatedUser == null) {
          return const SizedBox.shrink();
        }

        final bool isBlocked =
            updatedUser.isBlocked;

        return Container(

          height: Get.height * 0.82,

          decoration: const BoxDecoration(

            gradient: LinearGradient(
              colors: [

                Color(0xFF8E2DE2),
                Color(0xFFD59EFA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(35),
            ),
          ),

          child: Column(
            children: [

              const SizedBox(height: 12),

              TweenAnimationBuilder(

                tween: Tween(
                  begin: 0.7,
                  end: 1.0,
                ),

                duration: const Duration(
                  milliseconds: 600,
                ),

                curve: Curves.easeOutBack,

                builder:
                    (context, value, child) {

                  return Transform.scale(
                    scale: value as double,
                    child: child,
                  );
                },

                child: Container(

                  width: 70,
                  height: 5,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,

                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Row(
                  children: [

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

                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: [

                            Image.asset(
                              user.role == "Supervisor"
                                  ? "assets/images/nurs.png"
                                  : "assets/images/student.png",
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                            ),

                            /// 🔴 GREY OVERLAY WHEN BLOCKED
                            if (user.isBlocked)
                              Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.block,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            updatedUser.fullName,

                            style:
                            const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(

                            updatedUser.role,

                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(

                            updatedUser.email ?? "",

                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Column(
                  children: [

                    _actionButton(
                      title: isBlocked ? "Unblock" : "Block",
                      icon: isBlocked ? Icons.lock_open : Icons.lock,
                      color: isBlocked ? Colors.green : Colors.orange,
                      onTap: () async {
                        await c.toggleBlock(updatedUser);
                      },
                    ),

                    const SizedBox(height: 15),

                    _actionButton(

                      title: "Delete User",

                      icon: Icons.delete,

                      color: Colors.red,

                      onTap: () {

                        Get.back();

                        c.deleteUser(updatedUser.id!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// =======================================================
  /// USER FORM
  /// =======================================================

  void _showUserForm(
      BuildContext context, {
        UserModel? user,
      }) {

    final isEdit =
        user != null;

    final nameController =
    TextEditingController(
      text: user?.fullName ?? "",
    );

    final emailController =
    TextEditingController(
      text: user?.email ?? "",
    );

    final passwordController =
    TextEditingController();

    final specController =
    TextEditingController(
      text: user?.specialization ?? "",
    );

    final identifierController =
    TextEditingController(

      text:
      user?.role == "Student"
          ? user?.studentIdentifier
          : user?.supervisorIdentifier,
    );

    Get.bottomSheet(

      isScrollControlled: true,

      Container(

        padding:
        const EdgeInsets.all(20),

        decoration:
        const BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.only(
              bottom:
              MediaQuery.of(context)
                  .viewInsets
                  .bottom,
            ),

            child: Column(
              mainAxisSize:
              MainAxisSize.min,

              children: [

                TweenAnimationBuilder(

                  tween: Tween(
                    begin: 0.7,
                    end: 1.0,
                  ),

                  duration: const Duration(
                    milliseconds: 700,
                  ),

                  curve: Curves.elasticOut,

                  builder:
                      (context, value, child) {

                    return Transform.scale(
                      scale: value as double,
                      child: child,
                    );
                  },

                  child: Text(

                    isEdit
                        ? "Edit User"
                        : "Add New User",

                    style:
                    const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A0891),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _field(
                  "Full Name",
                  nameController,
                ),

                _field(
                  "Email",
                  emailController,
                ),

                if (!isEdit)

                  _field(
                    "Password",
                    passwordController,
                    obscure: true,
                  ),

                _field(
                  "Specialization",
                  specController,
                ),

                _field(

                  c.filter.value == "Students"
                      ? "Student Identifier"
                      : "Supervisor Identifier",

                  identifierController,
                ),

                const SizedBox(height: 25),

                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(0xFF5A0891),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {

                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty) {

                        Get.snackbar(
                          "Warning",
                          "Please fill required fields",
                        );

                        return;
                      }

                      UserModel updatedUser = UserModel(

                        id: user?.id,

                        fullName:
                        nameController.text,

                        email:
                        emailController.text,

                        password:
                        passwordController.text.isNotEmpty
                            ? passwordController.text
                            : null,

                        specialization:
                        specController.text,

                        studentIdentifier:
                        c.filter.value == "Students"
                            ? identifierController.text
                            : null,

                        supervisorIdentifier:
                        c.filter.value == "Supervisors"
                            ? identifierController.text
                            : null,

                        role:
                        isEdit
                            ? user.role
                            : (c.filter.value == "Students"
                            ? "Student"
                            : "Supervisor"),
                      );

                      if (isEdit) {

                        c.updateUser(updatedUser);

                      } else {

                        c.addUser(updatedUser);
                      }
                    },

                    child: Text(

                      isEdit
                          ? "Save Changes"
                          : "Add User",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
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
        bool obscure = false,
      }) {

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 12),

      child: TextField(

        controller: c,

        obscureText: obscure,

        decoration: InputDecoration(

          filled: true,

          fillColor:
          const Color(0xFFF8F5FF),

          labelText: hint,

          labelStyle: TextStyle(
            color: Colors.grey.shade700,
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

            borderSide:
            BorderSide.none,
          ),

          focusedBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(14),

            borderSide:
            const BorderSide(
              color: Color(0xFF8E2DE2),
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  /// =======================================================
  /// ACTION BUTTON
  /// =======================================================

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}