import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/RoomController.dart';
import '../model/DormitoryUnitModel.dart';
import '../model/RoomModel.dart';

class UnitDetailsView extends StatelessWidget {
  final RoomController roomController = Get.put(RoomController());

  UnitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final DormitoryUnitModel unit = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      roomController.fetchRooms(unit.id);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),

      appBar: AppBar(
        title: Text("غرف ${unit.name}"),
        backgroundColor: const Color(0xFF5A0891),
      ),

      body: Obx(() {
        if (roomController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 🔥 تصغير + زيادة عدد الكاردات
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85, // 🔥 أصغر وأطول شوي
          ),
          itemCount: roomController.rooms.length,
          itemBuilder: (context, index) {
            final RoomModel room = roomController.rooms[index];
            return _buildRoomCard(room, unit.id);
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5A0891),
        child: const Icon(Icons.add),
        onPressed: () => _addDialog(unit.id),
      ),
    );
  }

  /// 🟣 ROOM CARD
  Widget _buildRoomCard(RoomModel room, int unitId) {
    return GestureDetector(
        onTap: () {
          Get.toNamed(
            '/room-details',
            arguments: room,
          );
        },

        child:Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          /// 🖼️ IMAGE FULL CARD
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/room.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🟣 BOTTOM GRADIENT BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8E24AA),
                    Color(0xFF5A0891),
                  ],
                ),
              ),
              child: Text(
                "Room ${room.roomNumber}\nCap: ${room.capacity}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// ❌ DELETE (بدون دائرة)
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: () => roomController.deleteRoom(room.id, unitId),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),

          /// ✏️ EDIT (بدون دائرة)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _editDialog(room, unitId),
              child: const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  /// ➕ ADD ROOM
  void _addDialog(int unitId) {
    final roomNumber = TextEditingController();
    final capacity = TextEditingController();

    Get.defaultDialog(
      title: "إضافة غرفة",
      content: Column(
        children: [
          TextField(
            controller: roomNumber,
            decoration: const InputDecoration(hintText: "رقم الغرفة"),
          ),
          TextField(
            controller: capacity,
            decoration: const InputDecoration(hintText: "السعة"),
          ),
        ],
      ),
      textConfirm: "إضافة",
      onConfirm: () {
        roomController.addRoom(
          unitId: unitId,
          roomNumber: roomNumber.text,
          capacity: int.tryParse(capacity.text) ?? 0,
        );
        Get.back();
      },
    );
  }

  /// ✏️ EDIT ROOM
  void _editDialog(RoomModel room, int unitId) {
    final capacity =
    TextEditingController(text: room.capacity.toString());

    Get.defaultDialog(
      title: "تعديل الغرفة",
      content: TextField(
        controller: capacity,
        decoration: const InputDecoration(hintText: "السعة"),
      ),
      textConfirm: "تعديل",
      onConfirm: () {
        roomController.updateRoom(
          roomId: room.id,
          unitId: unitId,
          capacity: int.tryParse(capacity.text) ?? 0,
        );
        Get.back();
      },
    );
  }
}