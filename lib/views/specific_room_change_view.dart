import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/request_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/widgets/custom_textfield.dart';
import 'package:studants/widgets/gradient_button.dart';

class SpecificRoomChangeView extends StatefulWidget {
  const SpecificRoomChangeView({super.key});

  @override
  State<SpecificRoomChangeView> createState() => _SpecificRoomChangeViewState();
}

class _SpecificRoomChangeViewState extends State<SpecificRoomChangeView> {
  final RequestController controller = Get.isRegistered<RequestController>()
      ? Get.find<RequestController>()
      : Get.put(RequestController());

  final TextEditingController reasonController = TextEditingController();

  final RxnInt selectedUnitId = RxnInt();
  final RxnInt requestedRoomId = RxnInt();

  @override
  void initState() {
    super.initState();
    controller.getCurrentStudentRoom();
    controller.getRooms(availableOnly: true);
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

  String _unitNameFromRoom(dynamic room) {
    final unit = room['dormitory_unit'];

    final rawName = unit != null
        ? unit['name']?.toString()
        : room['dormitory_unit_name']?.toString();

    return _unitArabicName(rawName);
  }

  String _roomTitle(dynamic room) {
    final number = room['room_number'] ?? room['number'] ?? '-';
    return "غرفة $number";
  }

  List<Map<String, dynamic>> _unitsFromRooms() {
    final Map<int, Map<String, dynamic>> units = {};

    for (final room in controller.rooms) {
      final unitId = _unitIdFromRoom(room);
      if (unitId == null) continue;

      units[unitId] = {
        'id': unitId,
        'name': _unitNameFromRoom(room),
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
              "تبديل غرفة بدون بديلة",
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
        if (controller.isLoadingCurrentRoom.value ||
            controller.isLoadingRooms.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentRoom = controller.currentRoom.value;

        if (currentRoom == null) {
          return const Center(
            child: Text(
              "لم يتم تحميل الغرفة الحالية بعد، تأكدي أن الحساب مقيم بالسكن",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        if (controller.rooms.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد غرف متاحة حالياً",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.meeting_room,
                color: AppColors.darkPurple,
                size: 72,
              ),
              const SizedBox(height: 12),
              const Text(
                "اختاري الوحدة السكنية أولاً، ثم اختاري الغرفة المطلوبة واكتبي السبب.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),
              _currentRoomCard(currentRoom),
              const SizedBox(height: 20),
              _unitDropdown(),
              const SizedBox(height: 14),
              _roomDropdown(),
              const SizedBox(height: 14),
              CustomTextField(
                controller: reasonController,
                hint: "سبب تبديل الغرفة",
                icon: Icons.edit_note,
              ),
              const SizedBox(height: 24),
              Obx(() => GradientButton(
                    text: "إرسال الطلب",
                    isLoading: controller.isSubmitting.value,
                    onTap: () {
                      if (selectedUnitId.value == null) {
                        Get.snackbar("تنبيه", "اختاري الوحدة السكنية");
                        return;
                      }

                      if (requestedRoomId.value == null) {
                        Get.snackbar("تنبيه", "اختاري الغرفة المطلوبة");
                        return;
                      }

                      controller.createSpecificRoomRequest(
                        requestedRoomId: requestedRoomId.value!,
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
    final unitName = _unitNameFromRoom(room);

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
            child: Text(
              "غرفتك الحالية: ${room['room_number']}  |  الوحدة: $unitName",
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitDropdown() {
    return Obx(() {
      final units = _unitsFromRooms();

      return DropdownButtonFormField<int>(
        value: selectedUnitId.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "الوحدة السكنية",
          labelStyle: const TextStyle(color: AppColors.darkPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.mauve),
          ),
        ),
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
          requestedRoomId.value = null;
        },
      );
    });
  }

  Widget _roomDropdown() {
    return Obx(() {
      if (selectedUnitId.value == null) {
        return _disabledBox("اختاري الوحدة أولاً لعرض الغرف");
      }

      final rooms = _filteredRooms();

      if (rooms.isEmpty) {
        return _disabledBox("لا توجد غرف متاحة في هذه الوحدة");
      }

      return DropdownButtonFormField<int>(
        value: requestedRoomId.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "الغرفة المطلوبة",
          labelStyle: const TextStyle(color: AppColors.darkPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.mauve),
          ),
        ),
        items: rooms.map((room) {
          final id = int.tryParse(room['id'].toString());
          if (id == null) return null;

          return DropdownMenuItem<int>(
            value: id,
            child: Text(
              _roomTitle(room),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).whereType<DropdownMenuItem<int>>().toList(),
        onChanged: (value) {
          requestedRoomId.value = value;
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