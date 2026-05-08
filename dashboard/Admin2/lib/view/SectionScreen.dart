import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/SectionController.dart';
import '../model/SectionModel.dart';
import 'SectionDetailsScreen.dart';

class SectionScreen extends StatefulWidget {
  SectionScreen({super.key});

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  final SectionController controller = Get.put(SectionController());

  final Gradient iconGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final List<bool> _visibleItems = [];

  @override
  void initState() {
    super.initState();

    ever(controller.sections, (_) {
      _startStagger();
    });
  }

  void _startStagger() {
    _visibleItems.clear();

    for (int i = 0; i < controller.sections.length; i++) {
      _visibleItems.add(false);

      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) {
          setState(() {
            _visibleItems[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      /// 🔥 APP BAR (LEFT ALIGNED)
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A0891),
        elevation: 0,

        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Sections Management",
            style: TextStyle(color: Colors.white),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchSections(),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8E2DE2),
        onPressed: () => _showSectionDialog(),
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sections.isEmpty) {
          return const Center(child: Text("No Sections Available"));
        }

        if (_visibleItems.length != controller.sections.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startStagger();
          });
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 9,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final section = controller.sections[index];

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: (_visibleItems.length > index &&
                  _visibleItems[index])
                  ? 1
                  : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 400),
                offset: (_visibleItems.length > index &&
                    _visibleItems[index])
                    ? Offset.zero
                    : const Offset(0, 0.3),
                child: _iconTile(section),
              ),
            );
          },
        );
      }),
    );
  }

  // 💎 TILE
  Widget _iconTile(SectionModel section) {
    RxBool pressed = false.obs;

    return GestureDetector(
      onTapDown: (_) => pressed.value = true,
      onTapUp: (_) => pressed.value = false,
      onTapCancel: () => pressed.value = false,
      onTap: () => Get.to(() => SectionDetailsScreen(section: section)),

      child: Obx(() => AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: pressed.value ? 0.92 : 1,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _miniBtn(Icons.edit, Colors.blue, () {
                  _showSectionDialog(model: section);
                }),
                const SizedBox(width: 6),
                _miniBtn(Icons.delete, Colors.red, () {
                  controller.deleteSection(section.id!);
                }),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: iconGradient,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8E2DE2).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Section ${section.sectionNumber}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              section.academicYear,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _miniBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 6,
            )
          ],
        ),
        child: Icon(icon, size: 13, color: color),
      ),
    );
  }

  void _showSectionDialog({SectionModel? model}) {
    final yearController =
    TextEditingController(text: model?.year.toString() ?? "");
    final academicController =
    TextEditingController(text: model?.academicYear ?? "");
    final noController =
    TextEditingController(text: model?.sectionNumber ?? "");

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "form",
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 400),

      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(Get.context!).size.width * 0.42,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    model == null ? "Add Section" : "Edit Section",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _input(yearController, "Year"),
                  const SizedBox(height: 8),
                  _input(academicController, "Academic Year"),
                  const SizedBox(height: 8),
                  _input(noController, "Section Code"),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E2DE2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (model == null) {
                          controller.addSection(
                            int.parse(yearController.text),
                            academicController.text,
                            noController.text,
                          );
                        } else {
                          controller.updateSection(
                            model.id!,
                            int.parse(yearController.text),
                            academicController.text,
                            noController.text,
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
        );
      },

      transitionBuilder: (_, anim, __, child) {
        final curve = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutBack,
        );

        return Transform.scale(
          scale: curve.value,
          child: Opacity(
            opacity: anim.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _input(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}