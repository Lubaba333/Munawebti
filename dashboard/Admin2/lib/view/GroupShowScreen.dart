import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/GroupController.dart';
import '../model/StudentModel.dart';
import '../widgets/AppColors.dart';

class GroupShowScreen extends StatelessWidget {
  final int groupId;

  const GroupShowScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupController>();

    // جلب بيانات الفئة المحددة من القائمة الموجودة في الكنترولر
    final group = controller.groups.firstWhere(
          (g) => g.id == groupId,
    );

    // استدعاء جلب الطلاب عند فتح الواجهة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchGroupStudents(groupId);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// APP BAR
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Group ${group.groupNumber}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    _buildCircle(-40, null, null, -30, 170),
                    _buildCircle(null, -50, -20, null, 140),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Hero(
                            tag: "group_${group.id}",
                            child: _buildHeaderIcon(),
                          ),
                          const SizedBox(height: 18),
                          Obx(() => Text(
                            "${controller.groupStudents.length} Students",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// OVERVIEW CARD
                  _buildOverviewCard(group, controller),

                  const SizedBox(height: 24),

                  /// DETAILS SECTION
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoTile(
                    icon: Icons.account_tree_rounded,
                    title: "Section",
                    value: group.section?.sectionNumber ?? "N/A",
                  ),
                  const SizedBox(height: 16),
                  _InfoTile(
                    icon: Icons.calendar_month_rounded,
                    title: "Academic Year",
                    value: group.section?.academicYear ?? "N/A",
                  ),

                  const SizedBox(height: 32),

                  /// STUDENTS LIST SECTION
                  _buildStudentsHeader(context, controller, group.sectionId),

                  const SizedBox(height: 16),

                  /// STUDENTS LIST
                  Obx(() {
                    if (controller.isStudentsLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.groupStudents.isEmpty) {
                      return _buildEmptyStudents();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.groupStudents.length,
                      itemBuilder: (context, index) {
                        final student = controller.groupStudents[index];
                        return _StudentTile(
                          student: student,
                          onDelete: () => _confirmDelete(context, controller, student),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // أداة بناء دوائر الخلفية
  Widget _buildCircle(double? top, double? bottom, double? left, double? right, double size) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.08),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // أيقونة الرأس
  Widget _buildHeaderIcon() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(.15), width: 1.5),
      ),
      child: const Icon(Icons.groups_rounded, color: Colors.white, size: 46),
    );
  }

  // كرت العرض العام
  Widget _buildOverviewCard(group, controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.dashboard_customize_rounded, color: AppColors.primary),
              SizedBox(width: 10),
              Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Obx(() => _StatCard(
                  title: "Students",
                  value: "${controller.groupStudents.length}",
                  icon: Icons.people_alt_rounded,
                )),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  title: "Group No",
                  value: group.groupNumber,
                  icon: Icons.badge_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // رأس قائمة الطلاب مع زر الإضافة
  Widget _buildStudentsHeader(BuildContext context, controller, int sectionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Students List",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        IconButton(
          onPressed: () => _showAssignDialog(context, controller, sectionId),
          icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 28),
        ),
      ],
    );
  }

  Widget _buildEmptyStudents() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text("No students assigned to this group yet", style: TextStyle(color: AppColors.grey)),
      ),
    );
  }

  // دايلوج توزيع طالب (Assign)
  void _showAssignDialog(BuildContext context, GroupController controller, int sectionId) {
    controller.fetchAvailableStudents(sectionId);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Select Student to Add", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isAvailableLoading.value) return const Center(child: CircularProgressIndicator());
                if (controller.availableStudents.isEmpty) return const Center(child: Text("No available students found"));
                return ListView.builder(
                  itemCount: controller.availableStudents.length,
                  itemBuilder: (context, index) {
                    final student = controller.availableStudents[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(student.fullName[0])),
                      title: Text(student.fullName),
                      subtitle: Text(student.studentIdentifier),
                      trailing: const Icon(Icons.add_circle, color: Colors.green),
                      onTap: () {
                        controller.assignStudentToGroup(groupId, student.id);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // تأكيد حذف طالب من الفئة
  void _confirmDelete(BuildContext context, GroupController controller, StudentModel student) {
    Get.defaultDialog(
      title: "Remove Student",
      middleText: "Are you sure you want to remove ${student.fullName} from this group?",
      textConfirm: "Remove",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.removeStudentFromGroup(groupId, student.id);
        Get.back();
      },
    );
  }
}

/// --- WIDGETS ---

class _StudentTile extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onDelete;

  const _StudentTile({required this.student, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(student.fullName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(student.specialization, style: TextStyle(color: AppColors.grey, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 22),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.05), blurRadius: 14, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.secondary.withOpacity(.12), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
                Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(title, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}