import 'package:admin2/view/violation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/UserManagement_controller.dart';
import '../model/user_model.dart';
import 'RewardsScreen.dart';
import 'WarningsScreen.dart';

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

    final RxInt selectedTab = 0.obs;

    Get.bottomSheet(
      isScrollControlled: true,
      Obx(() {

        final updatedUser =
        c.users.firstWhereOrNull((e) => e.id == user.id);

        if (updatedUser == null) {
          return const SizedBox.shrink();
        }

        final bool isBlocked = updatedUser.isBlocked;

        return Container(
          height: Get.height * 0.88,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8E2DE2),
                Color(0xFFD59EFA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(35),
            ),
          ),

          child: Column(
            children: [

              const SizedBox(height: 12),

              /// HANDLE
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              /// USER INFO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [

                    ClipRRect(
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

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            updatedUser.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(updatedUser.role),
                          const SizedBox(height: 6),

                          Text(updatedUser.email ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= TABS =================
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  _tabButton("Info", 0, selectedTab),
                  _tabButton("Rewards", 1, selectedTab),
                  _tabButton("Violations", 2, selectedTab),
                  _tabButton("Warnings", 3, selectedTab), // 🔥 NEW

                ],
              )),

              const SizedBox(height: 10),

              /// ================= CONTENT =================
              Expanded(
                child: Obx(() {

                  /// INFO
                  if (selectedTab.value == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          _actionButton(
                            title: isBlocked ? "Unblock" : "Block",
                            icon: isBlocked
                                ? Icons.lock_open
                                : Icons.lock,
                            color: isBlocked
                                ? Colors.green
                                : Colors.orange,
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
                    );
                  }

                  /// REWARDS
                  if (selectedTab.value == 1) {
                    return RewardsScreen(user: updatedUser);
                  }

                  /// VIOLATIONS
                  if (selectedTab.value == 2) {
                    return ViolationsScreen(user: updatedUser);
                  }

                  /// 🔥 WARNINGS (NEW)
                  return WarningsScreen(user: updatedUser);
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget _tabButton(String title, int index, RxInt selectedTab) {
    return GestureDetector(
      onTap: () => selectedTab.value = index,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedTab.value == index
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedTab.value == index
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }
  /// =======================================================
  /// USER FORM
  /// =======================================================
  void _showUserForm(BuildContext context, {UserModel? user}) {
    final isEdit = user != null;
    // نحدد الفلتر الحالي لنعرف أي واجهة نعرض (طالبة أم مشرفة)
    final bool isStudentFilter = c.filter.value == "Students";

    // تعريف المتحكمات (Controllers) مع إسناد القيم في حال التعديل
    final nameController = TextEditingController(text: user?.fullName ?? "");
    final emailController = TextEditingController(text: user?.email ?? "");
    final passwordController = TextEditingController();
    final specController = TextEditingController(text: user?.specialization ?? "");

    // حقل المعرف (يأخذ قيمته بناءً على نوع المستخدم)
    final identifierController = TextEditingController(
      text: user?.role == "Student"
          ? user?.studentIdentifier
          : user?.supervisorIdentifier,
    );

    // حقول خاصة بالطالبة (Required for Student Profile)
    final phoneController = TextEditingController(text: user?.phoneNumber ?? "+9639");
    final yearController = TextEditingController(text: user?.year ?? "4");
    final avgController = TextEditingController(text: user?.annualAverage ?? "85.0");

    // حقول خاصة بالمشرفة (Required for Supervisor Profile)
    final certPlaceController = TextEditingController(text: user?.certificatePlace ?? "");
    final certDateController = TextEditingController(text: user?.certificateDate ?? "2020-05-15");

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // لرفع الواجهة عند ظهور الكيبورد
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  isEdit ? "Edit data${user.role}" : "Add ${isStudentFilter ? 'student' : 'Supervisor'} New",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A0891),
                  ),
                ),
                const SizedBox(height: 20),

                // الحقول المشتركة
                _field("full name", nameController),
                _field("e-mail", emailController),

                if (!isEdit)
                  _field("Password (at least 8 characters)", passwordController, obscure: true),

                _field("Specialization", specController),

                // حقل المعرف الديناميكي
                _field(
                  isStudentFilter ? "University number (Identifier)" : "Job identification number",
                  identifierController,
                ),

                // عرض حقول الطالبة فقط إذا كان الفلتر "Students"
                if (isStudentFilter) ...[
                  _field("phone number", phoneController),
                  _field("Academic year", yearController),
                  _field("Annual rate", avgController),
                ],

                // عرض حقول المشرفة فقط إذا كان الفلتر "Supervisors"
                if (!isStudentFilter) ...[
                  _field("Place to obtain the certificate", certPlaceController),
                  _field("Date of certification (YYYY-MM-DD)", certDateController),
                ],

                const SizedBox(height: 25),

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A0891),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      // التحقق من الحقول الأساسية
                      if (nameController.text.isEmpty || emailController.text.isEmpty) {
                        Get.snackbar("alert", "Please fill in the required fields.");
                        return;
                      }

                      // بناء كائن المستخدم الجديد مع التأكد من إرسال كافة الحقول لتجنب 422
                      UserModel updatedUser = UserModel(
                        id: user?.id,
                        fullName: nameController.text,
                        email: emailController.text,
                        password: passwordController.text.isNotEmpty ? passwordController.text : null,
                        specialization: specController.text,
                        phoneNumber: phoneController.text, // مهم للطالبات

                        // حقول الطالبة
                        studentIdentifier: isStudentFilter ? identifierController.text : null,
                        year: isStudentFilter ? yearController.text : null,
                        annualAverage: isStudentFilter ? avgController.text : null,
                        isResident: true, // قيمة افتراضية

                        // حقول المشرفة
                        supervisorIdentifier: !isStudentFilter ? identifierController.text : null,
                        certificatePlace: !isStudentFilter ? certPlaceController.text : null,
                        certificateDate: !isStudentFilter ? certDateController.text : null,

                        role: isEdit
                            ? user.role
                            : (isStudentFilter ? "Student" : "Supervisor"),
                      );

                      // استدعاء دالة الحفظ الموحدة في الكنترولر
                      c.saveUser(updatedUser, isEdit: isEdit);
                    },
                    child: Text(
                      isEdit ? "Save modifications" : "Add user",
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