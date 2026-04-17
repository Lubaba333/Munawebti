import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ScheduleViewController.dart';
import 'package:admin2/widgets/AppColors.dart';

class ScheduleEditorScreen extends StatefulWidget {
  const ScheduleEditorScreen({super.key});

  @override
  State<ScheduleEditorScreen> createState() =>
      _ScheduleEditorScreenState();
}

class _ScheduleEditorScreenState
    extends State<ScheduleEditorScreen>
    with SingleTickerProviderStateMixin {

  final controller = Get.put(ScheduleEditorController());

  late AnimationController _animationController;
  late FocusNode _focusNode;

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ================= SEARCH =================
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: Focus(
        onFocusChange: (_) => setState(() {}),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            /// 🔥 الخلفية ثابتة (ما تتغير)
            color: Colors.white,

            /// 🔥 الإطار فقط يتغير لونه
            border: Border.all(
              color: _focusNode.hasFocus
                  ? const Color(0xFF5A0891) // نفس لون الايقونة
                  : Colors.grey.shade300,
              width: _focusNode.hasFocus ? 2.5 : 1,
            ),

            /// ظل خفيف عند التركيز
            boxShadow: [
              if (_focusNode.hasFocus)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
            ],
          ),

          child: TextField(
            focusNode: _focusNode,
            onChanged: controller.search,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            decoration: InputDecoration(
              hintText: "Search employee...",
              hintStyle: TextStyle(color: Colors.grey.shade500),

              prefixIcon: Icon(
                Icons.search_rounded,
                color: _focusNode.hasFocus
                    ? const Color(0xFF8E2DE2)
                    : Colors.grey,
              ),

              suffixIcon: Obx(() {
                return controller.searchText.value.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.search(""),
                )
                    : const SizedBox();
              }),

              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // ================= APPBAR =================
      appBar:PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Schedule Eidt",
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        return Column(
          children: [

            _searchBar(),

            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final value = Curves.elasticOut
                      .transform(_animationController.value);

                  return Opacity(
                    opacity: _animationController.value,
                    child: Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: child,
                    ),
                  );
                },

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [

                      // HEADER
                      Row(
                        children: [
                          _cell("Employee", true),
                          ...List.generate(
                            controller.days.value,
                                (i) => _cell("D${i + 1}", true),
                          ),
                        ],
                      ),

                      // ROWS
                      ...List.generate(
                        controller.items.length,
                            (row) {
                          final item = controller.items[row];

                          return Row(
                            children: [
                              _cell(item.employee, false),

                              ...List.generate(
                                controller.days.value,
                                    (col) {
                                  return _cellEditable(
                                    row,
                                    col,
                                    item.shifts[col],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ================= EDITABLE CELL =================
  Widget _cellEditable(int row, int col, String value) {

    final key = "$row-$col";

    return Obx(() {
      final isEditing = controller.editingCell.value == key;

      if (isEditing) {
        final txt = TextEditingController(text: value);

        return Container(
          width: 110,
          height: 65,
          margin: const EdgeInsets.all(4),
          child: TextField(
            controller: txt,
            autofocus: true,
            onSubmitted: (v) {
              controller.editShift(row, col, v);
              controller.clearEditing();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: () => controller.setEditing(row, col),

        child: DragTarget<Map>(
          onAccept: (data) {
            controller.swapShift(
              data["row"],
              data["col"],
              row,
              col,
            );
          },

          builder: (context, _, __) {
            return Draggable<Map>(
              data: {"row": row, "col": col},

              feedback: Material(
                color: Colors.transparent,
                child: _box(value),
              ),

              child: _box(value),
            );
          },
        ),
      );
    });
  }

  // ================= CELL BOX (ORIGINAL COLORS) =================
  Widget _box(String value) {
    return Container(
      width: 110,
      height: 65,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getColor(value),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _cell(String text, bool header) {
    return Container(
      width: 120,
      height: 65,
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: header
            ? const Color(0xFF5A0891)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: header ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Color> _getColor(String shift) {
    switch (shift) {
      case "M":
        return [Colors.green, Colors.greenAccent];
      case "N":
        return [Colors.blue, Colors.lightBlueAccent];
      case "O":
        return [Colors.grey, Colors.blueGrey];
      default:
        return [Colors.white, Colors.white];
    }
  }
}