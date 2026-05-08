import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/GroupController.dart';
import '../model/SectionModel.dart';
import '../model/GroupModel.dart';
import 'GroupShowScreen.dart';

class SectionDetailsScreen extends StatefulWidget {
  final SectionModel section;

  const SectionDetailsScreen({super.key, required this.section});

  @override
  State<SectionDetailsScreen> createState() => _SectionDetailsScreenState();
}

class _SectionDetailsScreenState extends State<SectionDetailsScreen>
    with SingleTickerProviderStateMixin {
  final GroupController controller = Get.put(GroupController());

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          iconTheme: const IconThemeData(
            color: Colors.white,
          ),

          title: Text(
            "Section ${widget.section.sectionNumber}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: headerGradient,
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => controller.fetchGroups(),
            ),
          ],
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8E2DE2),
        child: const Icon(Icons.group_add),
        onPressed: () =>
            _showGroupDialog(sectionId: widget.section.id!),
      ),

      body: Obx(() {
        final groups = controller.groups
            .where((g) => g.sectionId == widget.section.id)
            .toList();

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (groups.isEmpty) {
          return const Center(child: Text("No groups found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: groups.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.90,
          ),

          itemBuilder: (context, index) {
            final group = groups[index];

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 80)),
              tween: Tween(begin: 0.0, end: 1.0),

              builder: (context, v, child) {
                final value = v.clamp(0.0, 1.0);

                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },

              child: _groupIcon(group),
            );
          },
        );
      }),
    );
  }

  /// 💜 GROUP ICON (FIXED + BIG + ACTIONS ON CORNERS)
  Widget _groupIcon(GroupModel group) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,

      builder: (context, v, child) {
        final value = v.clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: Transform.scale(
              scale: 0.85 + (0.15 * value),
              child: child,
            ),
          ),
        );
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// 💜 ICON AREA WITH TOP ACTIONS
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [

              /// 💜 MAIN ICON ONLY
              GestureDetector(
                onTap: () => Get.to(() => GroupShowScreen(groupId: group.id!)),
                child: const Icon(
                  Icons.groups,
                  color: Color(0xFF8E2DE2),
                  size: 78, // 🔥 أكبر شوي
                ),
              ),

              /// ✏️ EDIT (TOP LEFT)
              Positioned(
                top: -6,
                left: -6,
                child: _actionBtn(
                  icon: Icons.edit,
                  color: Colors.blue,
                  onTap: () {
                    _showGroupDialog(
                      model: group,
                      sectionId: group.sectionId,
                    );
                  },
                ),
              ),

              /// 🗑 DELETE (TOP RIGHT)
              Positioned(
                top: -6,
                right: -6,
                child: _actionBtn(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () {
                    controller.deleteGroup(group.id!);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// TEXT
          Text(
            "G${group.groupNumber}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          Text(
            "${group.studentsCount ?? 0}",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }

  /// 🚀 DIALOG
  void _showGroupDialog({GroupModel? model, required int sectionId}) {
    final textController =
    TextEditingController(text: model?.groupNumber ?? "");

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "group_form",
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 350),

      pageBuilder: (context, anim1, anim2) {
        return const SizedBox();
      },

      transitionBuilder: (context, anim, secAnim, child) {
        final curve = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutBack,
        );

        return Transform.scale(
          scale: curve.value,
          child: Opacity(
            opacity: anim.value,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 260, // 🔥 صغير جداً
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// TITLE
                      Text(
                        model == null ? "Add Group" : "Edit Group",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// INPUT
                      TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "Group name",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8E2DE2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (textController.text.isEmpty) return;

                            if (model == null) {
                              controller.addGroup(
                                textController.text,
                                sectionId,
                              );
                            } else {
                              controller.updateGroup(
                                model.id!,
                                textController.text,
                                sectionId,
                              );
                            }

                            Get.back();
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}