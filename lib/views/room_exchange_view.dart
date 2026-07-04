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

  final RxnInt selectedUnitId = RxnInt();
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
        return "building_1".tr;
      case "Building B":
        return "building_2".tr;
      case "Building C":
        return "building_3".tr;
      default:
        return name ?? "not_specified".tr;
    }
  }

  String _unitName(dynamic room) {
    final unit = room['dormitory_unit'];
    final rawName = unit != null
        ? unit['name']?.toString()
        : room['dormitory_unit_name']?.toString();

    return _unitArabicName(rawName);
  }

  int? _unitIdFromRoom(dynamic room) {
    final unit = room['dormitory_unit'];

    if (unit != null && unit['id'] != null) {
      return int.tryParse(unit['id'].toString());
    }

    if (room['dormitory_unit_id'] != null) {
      return int.tryParse(room['dormitory_unit_id'].toString());
    }

    return null;
  }

  List<Map<String, dynamic>> _unitsFromRooms() {
    final Map<int, Map<String, dynamic>> units = {};

    for (final room in controller.rooms) {
      final unitId = _unitIdFromRoom(room);
      if (unitId == null) continue;

      units[unitId] = {
        'id': unitId,
        'name': _unitName(room),
      };
    }

    return units.values.toList();
  }

  List<dynamic> _filteredRooms() {
    final currentId = controller.currentRoom.value?['id'];

    return controller.rooms.where((room) {
      final roomId = int.tryParse(room['id'].toString());
      final unitId = _unitIdFromRoom(room);

      if (roomId == currentId) return false;
      if (selectedUnitId.value == null) return false;

      return unitId == selectedUnitId.value;
    }).toList();
  }

  String _roomTitle(dynamic room) {
    final number = room['room_number'] ?? room['number'] ?? '-';
    return "${"room".tr}: $number";
  }

  String _studentTitle(dynamic student) {
    final name = student['full_name'] ?? student['name'] ?? "student".tr;
    final identifier = student['student_identifier'];
    if (identifier != null) {
      return "$name • $identifier";
    }
    return name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.currentGradient),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _form(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(.18)),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "room_exchange_with_student".tr,
              style: const TextStyle(
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

  Widget _form(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.22)
                : AppColors.deepPurple.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoadingCurrentRoom.value ||
            controller.isLoadingRooms.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          );
        }

        final currentRoom = controller.currentRoom.value;

        if (currentRoom == null) {
          return Center(
            child: Text(
              "current_room_loading".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.swap_horiz,
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
                size: 76,
              ),
              const SizedBox(height: 12),
              Text(
                "room_exchange_desc".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 22),
              _currentRoomCard(context, currentRoom),
              const SizedBox(height: 18),
              _unitDropdown(context),
              const SizedBox(height: 14),
              _roomDropdown(context),
              const SizedBox(height: 14),
              _studentDropdown(context),
              const SizedBox(height: 14),
              CustomTextField(
                controller: reasonController,
                hint: "exchange_reason".tr,
                icon: Icons.edit_note,
              ),
              const SizedBox(height: 24),
              Obx(
                () => GradientButton(
                  text: "send_exchange_request".tr,
                  isLoading: controller.isSubmitting.value,
                  onTap: () {
                    if (selectedUnitId.value == null) {
                      Get.snackbar("warning".tr, "choose_unit".tr);
                      return;
                    }

                    if (targetRoomId.value == null) {
                      Get.snackbar("warning".tr, "choose_exchange_room".tr);
                      return;
                    }

                    if (targetStudentId.value == null) {
                      Get.snackbar("warning".tr, "choose_exchange_student".tr);
                      return;
                    }

                    controller.createExchangeRoomRequest(
                      targetRoomId: targetRoomId.value!,
                      targetStudentId: targetStudentId.value!,
                      reason: reasonController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _currentRoomCard(BuildContext context, Map<String, dynamic> room) {
    final isDark = Get.isDarkMode;
    final unitName = _unitName(room);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.07)
            : AppColors.softLavender,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? AppColors.mauve.withOpacity(.20)
              : AppColors.mauve.withOpacity(.4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isDark ? AppColors.mauve.withOpacity(.16) : Colors.white,
            child: Icon(
              Icons.home,
              color: isDark ? AppColors.mauve : AppColors.darkPurple,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "current_room".tr,
                  style: TextStyle(
                    color: isDark ? AppColors.mauve : AppColors.darkPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${"room".tr}: ${room['room_number']}  |  ${"unit".tr}: $unitName",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
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

  InputDecoration _dropdownDecoration(BuildContext context, String label) {
    final isDark = Get.isDarkMode;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? AppColors.mauve : AppColors.darkPurple,
      ),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(.05) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.mauve.withOpacity(.22)
              : AppColors.mauve.withOpacity(.35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.mauve),
      ),
    );
  }

  Widget _unitDropdown(BuildContext context) {
    return Obx(() {
      final units = _unitsFromRooms();

      return DropdownButtonFormField<int>(
        value: selectedUnitId.value,
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        decoration: _dropdownDecoration(context, "unit".tr),
        items: units.map((unit) {
          return DropdownMenuItem<int>(
            value: unit['id'],
            child: Text(
              unit['name'],
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          selectedUnitId.value = value;
          targetRoomId.value = null;
          targetStudentId.value = null;
          controller.roomStudents.clear();
        },
      );
    });
  }

  Widget _roomDropdown(BuildContext context) {
    return Obx(() {
      if (selectedUnitId.value == null) {
        return _disabledBox(context, "choose_building_first".tr);
      }

      final availableRooms = _filteredRooms();

      if (availableRooms.isEmpty) {
        return _disabledBox(context, "no_rooms_in_building".tr);
      }

      return DropdownButtonFormField<int>(
        value: targetRoomId.value,
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        decoration: _dropdownDecoration(context, "exchange_room".tr),
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

  Widget _studentDropdown(BuildContext context) {
    return Obx(() {
      if (targetRoomId.value == null) {
        return _disabledBox(context, "choose_room_first_for_students".tr);
      }

      if (controller.isLoadingRoomStudents.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          ),
        );
      }

      if (controller.roomStudents.isEmpty) {
        return _disabledBox(context, "no_students_in_room".tr);
      }

      return DropdownButtonFormField<int>(
        value: targetStudentId.value,
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        decoration: _dropdownDecoration(context, "exchange_student".tr),
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

  Widget _disabledBox(BuildContext context, String text) {
    final isDark = Get.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.06)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.mauve.withOpacity(.18)
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}