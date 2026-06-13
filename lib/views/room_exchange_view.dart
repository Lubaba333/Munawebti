import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';

class RoomExchangeView extends StatefulWidget {
  const RoomExchangeView({super.key});

  @override
  State<RoomExchangeView> createState() => _RoomExchangeViewState();
}

class _RoomExchangeViewState extends State<RoomExchangeView> {
  final RequestController controller = Get.isRegistered<RequestController>()
      ? Get.find<RequestController>()
      : Get.put(RequestController());

  final reasonController = TextEditingController();

  final RxnInt targetRoomId = RxnInt();
  final RxnInt targetStudentId = RxnInt();

  @override
  void initState() {
    super.initState();
    controller.getCurrentStudentRoom();
    controller.getRooms();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  String _unitArabicName(String? name) {
    switch (name) {
      case "Building A":
        return "مبنى الطالبات الأول";
      case "Building B":
        return "مبنى الطالبات الثاني";
      case "Building C":
        return "مبنى الطالبات الثالث";
      default:
        return name ?? "غير محدد";
    }
  }

  String _unitName(dynamic room) {
    final unit = room['dormitory_unit'];
    final rawName = unit != null
        ? unit['name']?.toString()
        : room['dormitory_unit_name']?.toString();

    return _unitArabicName(rawName);
  }

  String _roomTitle(dynamic room) {
    final number = room['room_number'] ?? room['number'] ?? '-';
    return "الغرفة: $number  |  الوحدة: ${_unitName(room)}";
  }

  String _studentTitle(dynamic student) {
    final name = student['full_name'] ?? student['name'] ?? 'طالبة';
    final identifier = student['student_identifier'];
    if (identifier != null) {
      return "$name • $identifier";
    }
    return name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _form()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              "تبديل غرفة مع طالبة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Obx(() {
        if (controller.isLoadingCurrentRoom.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentRoom = controller.currentRoom.value;

        if (currentRoom == null) {
          return const Center(
            child: Text(
              "لم يتم تحميل غرفتك الحالية بعد",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.swap_horiz,
                color: AppColors.darkPurple,
                size: 76,
              ),
              const SizedBox(height: 12),
              const Text(
                "غرفتك الحالية ثابتة من حسابك. اختاري غرفة الطالبة البديلة، ثم اختاري اسم الطالبة واكتبي السبب.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              _currentRoomCard(currentRoom),
              const SizedBox(height: 18),
              _roomDropdown(),
              const SizedBox(height: 14),
              _studentDropdown(),
              const SizedBox(height: 14),
              CustomTextField(
                controller: reasonController,
                hint: "سبب التبديل",
                icon: Icons.edit_note,
              ),
              const SizedBox(height: 24),
              Obx(() => GradientButton(
                    text: "إرسال طلب التبديل",
                    isLoading: controller.isSubmitting.value,
                    onTap: () {
                      if (targetRoomId.value == null) {
                        Get.snackbar(
                            "تنبيه", "اختاري الغرفة المراد التبديل معها");
                        return;
                      }

                      if (targetStudentId.value == null) {
                        Get.snackbar("تنبيه", "اختاري الطالبة البديلة");
                        return;
                      }

                      controller.createExchangeRoomRequest(
                        targetRoomId: targetRoomId.value!,
                        targetStudentId: targetStudentId.value!,
                        reason: reasonController.text,
                      );
                    },
                  )),
            ],
          ),
        );
      }),
    );
  }

  Widget _currentRoomCard(Map<String, dynamic> room) {
    final unitName = _unitName(room);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.mauve.withOpacity(.4)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.home, color: AppColors.darkPurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "غرفتك الحالية",
                  style: TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "الغرفة: ${room['room_number']}  |  الوحدة: $unitName",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomDropdown() {
    return Obx(() {
      final currentId = controller.currentRoom.value?['id'];

      final availableRooms = controller.rooms.where((room) {
        final roomId = int.tryParse(room['id'].toString());
        return roomId != currentId;
      }).toList();

      return DropdownButtonFormField<int>(
        value: targetRoomId.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "الغرفة المراد التبديل معها",
          labelStyle: const TextStyle(color: AppColors.darkPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.mauve),
          ),
        ),
        items: availableRooms
            .map((room) {
              final id = int.tryParse(room['id'].toString());
              if (id == null) return null;

              return DropdownMenuItem<int>(
                value: id,
                child: Text(
                  _roomTitle(room),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            })
            .whereType<DropdownMenuItem<int>>()
            .toList(),
        onChanged: (value) async {
          targetRoomId.value = value;
          targetStudentId.value = null;
          controller.roomStudents.clear();

          if (value != null) {
            await controller.getRoomStudents(value);
          }
        },
      );
    });
  }

  Widget _studentDropdown() {
    return Obx(() {
      if (targetRoomId.value == null) {
        return _disabledBox("اختاري الغرفة أولاً لعرض الطالبات");
      }

      if (controller.isLoadingRoomStudents.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.roomStudents.isEmpty) {
        return _disabledBox("لا توجد طالبات في هذه الغرفة");
      }

      return DropdownButtonFormField<int>(
        value: targetStudentId.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "الطالبة البديلة",
          labelStyle: const TextStyle(color: AppColors.darkPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.mauve),
          ),
        ),
        items: controller.roomStudents
            .map((student) {
              final id = int.tryParse(student['id'].toString());
              if (id == null) return null;

              return DropdownMenuItem<int>(
                value: id,
                child: Text(
                  _studentTitle(student),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            })
            .whereType<DropdownMenuItem<int>>()
            .toList(),
        onChanged: (value) {
          targetStudentId.value = value;
        },
      );
    });
  }

  Widget _disabledBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}