import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

/// ================= ROOM =================
class Room {
  final String id;

  String name;
  int capacity;
  String imageUrl;
  List<String> users;
  String notes;

  Room({
    required this.name,
    required this.capacity,
    required this.imageUrl,
    required this.users,
    this.notes = "",
  }) : id = UniqueKey().toString();

  bool get isFull => users.length >= capacity;
}

/// ================= BUILDING =================
class Building {
  final String id;

  String name;
  String imageUrl;
  List<Room> rooms;

  Building({
    required this.name,
    required this.imageUrl,
    required this.rooms,
  }) : id = UniqueKey().toString();
}

/// ================= CONTROLLER =================
class HousingController extends GetxController {

  var buildings = <Building>[].obs;
  var selectedFilter = "all".obs;

  @override
  void onInit() {
    super.onInit();

    buildings.addAll([
      Building(
        name: "Block A",
        imageUrl: "assets/images/house.jpg",
        rooms: [
          Room(
            name: "A1",
            imageUrl: "assets/images/room.jpg",
            capacity: 4,
            users: ["Ali", "Sara"],
            notes: "Near window",
          ),
          Room(
            name: "A2",
            imageUrl: "assets/images/room.jpg",
            capacity: 3,
            users: [],
            notes: "",
          ),
        ],
      ),

      Building(
        name: "Block A",
        imageUrl: "assets/images/house.jpg",
        rooms: [
          Room(
            name: "A1",
            imageUrl: "assets/images/room.jpg",
            capacity: 4,
            users: ["Ali", "Sara"],
            notes: "Near window",
          ),
          Room(
            name: "A2",
            imageUrl: "assets/images/room.jpg",
            capacity: 3,
            users: [],
            notes: "",
          ),
        ],
      ),   Building(
        name: "Block A",
        imageUrl: "assets/images/house.jpg",
        rooms: [
          Room(
            name: "A1",
            imageUrl: "assets/images/room.jpg",
            capacity: 4,
            users: ["Ali", "Sara"],
            notes: "Near window",
          ),
          Room(
            name: "A2",
            imageUrl: "assets/images/room.jpg",
            capacity: 3,
            users: [],
            notes: "",
          ),
        ],
      ),   Building(
        name: "Block A",
        imageUrl: "assets/images/house.jpg",
        rooms: [
          Room(
            name: "A1",
            imageUrl: "assets/images/room.jpg",
            capacity: 4,
            users: ["Ali", "Sara"],
            notes: "Near window",
          ),
          Room(
            name: "A2",
            imageUrl: "assets/images/room.jpg",
            capacity: 3,
            users: [],
            notes: "",
          ),
        ],
      ),    ]);
  }

  // ================= FILTER ROOMS =================
  List<Room> getFilteredRooms(List<Room> rooms) {
    if (selectedFilter.value == "all") return rooms;

    if (selectedFilter.value == "empty") {
      return rooms.where((r) => r.users.isEmpty).toList();
    }

    if (selectedFilter.value == "full") {
      return rooms.where((r) => r.isFull).toList();
    }

    return rooms;
  }

  // ================= ADD STUDENT =================
  void addStudent(Room room, String name) {
    if (room.isFull) {
      Get.snackbar("Error", "Room is full");
      return;
    }

    room.users.add(name);
    buildings.refresh();
  }

  // ================= REMOVE STUDENT =================
  void removeStudent(Room room, String name) {
    room.users.remove(name);
    buildings.refresh();
  }

  // ================= UPDATE CAPACITY =================
  void updateCapacity(Room room, int newCapacity) {
    if (newCapacity >= room.users.length) {
      room.capacity = newCapacity;
      buildings.refresh();
    } else {
      Get.snackbar("Error", "Capacity too small");
    }
  }

  // ================= UPDATE NOTES =================
  void updateNotes(Room room, String text) {
    room.notes = text;
    buildings.refresh();
  }

  void moveStudent({
    required Room from,
    required Room to,
    required String student,
  }) {
    if (to.isFull) {
      Get.snackbar("Room Full", "Cannot add more students");
      return;
    }

    from.users.remove(student);
    to.users.add(student);

    buildings.refresh();
  }
}