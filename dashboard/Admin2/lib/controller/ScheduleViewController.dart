import 'package:get/get.dart';

class ScheduleItem {
  String employee;
  List<String> shifts;

  ScheduleItem({
    required this.employee,
    required this.shifts,
  });
}

class ScheduleEditorController extends GetxController {

  var days = 7.obs;

  var allItems = <ScheduleItem>[
    ScheduleItem(employee: "Fatima", shifts: ["M","N","O","M","N","O","M"]),
    ScheduleItem(employee: "Sara", shifts: ["N","M","O","N","M","O","N"]),
    ScheduleItem(employee: "Ali", shifts: ["O","M","N","O","M","N","O"]),
  ].obs;

  var items = <ScheduleItem>[].obs;

  var searchText = "".obs;

  var editingCell = "".obs; // 🔥 NEW

  @override
  void onInit() {
    super.onInit();
    items.assignAll(allItems);
  }

  // ================= SEARCH =================
  void search(String value) {
    searchText.value = value;

    if (value.isEmpty) {
      items.assignAll(allItems);
    } else {
      items.assignAll(
        allItems.where(
              (e) => e.employee.toLowerCase().contains(value.toLowerCase()),
        ),
      );
    }
  }

  // ================= SWAP =================
  void swapShift(int fromRow, int fromCol, int toRow, int toCol) {

    final item1 = items[fromRow];
    final item2 = items[toRow];

    final realIndex1 =
    allItems.indexWhere((e) => e.employee == item1.employee);

    final realIndex2 =
    allItems.indexWhere((e) => e.employee == item2.employee);

    final temp = allItems[realIndex1].shifts[fromCol];

    allItems[realIndex1].shifts[fromCol] =
    allItems[realIndex2].shifts[toCol];

    allItems[realIndex2].shifts[toCol] = temp;

    search(searchText.value);
  }

  // ================= EDIT SHIFT =================
  void editShift(int row, int col, String value) {

    final item = items[row];

    final realIndex = allItems.indexWhere(
          (e) => e.employee == item.employee,
    );

    if (realIndex == -1) return;

    allItems[realIndex].shifts[col] = value;

    search(searchText.value);
  }

  // ================= EDIT MODE =================
  void setEditing(int row, int col) {
    editingCell.value = "$row-$col";
  }

  void clearEditing() {
    editingCell.value = "";
  }
}