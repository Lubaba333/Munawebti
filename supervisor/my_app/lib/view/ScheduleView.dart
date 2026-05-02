// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_app/controller/ScheduleController.dart';


// class ScheduleView extends StatelessWidget {
//   final controller = Get.put(ScheduleController());

//   ScheduleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFF5EFE7),
//               Color(0xFFEDE3F3),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [

//               /// 🔥 Header
//               _header(),

//               /// 🔥 Calendar Strip
//               _calendarStrip(),

//               /// 🔥 Body
//               Expanded(
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   return ListView(
//                     padding: EdgeInsets.all(20),
//                     children: [

//                       /// Today
//                       ...controller.shifts
//                           .where((s) => s['status'] == 'today')
//                           .map((shift) => _todayCard(shift)),

//                       SizedBox(height: 20),

//                       Text("Upcoming",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),

//                       SizedBox(height: 10),

//                       ...controller.shifts
//                           .where((s) => s['status'] == 'upcoming')
//                           .map((shift) => _shiftCard(shift)),

//                       SizedBox(height: 20),

//                       Text("Completed",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),

//                       SizedBox(height: 10),

//                       ...controller.shifts
//                           .where((s) => s['status'] == 'done')
//                           .map((shift) => _shiftCard(shift)),
//                     ],
//                   );
//                 }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔥 Header
//   Widget _header() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Thursday, Apr 23",
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 "Your Schedule",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: Color(0xFFA467A7),
//             child: Icon(Icons.person, color: Colors.white),
//           )
//         ],
//       ),
//     );
//   }

//   /// 🔥 Calendar Strip
//   Widget _calendarStrip() {
//     return Container(
//       height: 90,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: controller.days.length,
//         itemBuilder: (context, index) {
//           final day = controller.days[index];

//           return Obx(() {
//             bool isSelected = controller.selectedIndex.value == index;

//             return GestureDetector(
//               onTap: () => controller.selectDay(index),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 margin: EdgeInsets.symmetric(horizontal: 8),
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Color(0xFFA467A7)
//                       : Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: isSelected
//                           ? Color(0xFFA467A7).withOpacity(0.4)
//                           : Colors.black12,
//                       blurRadius: 10,
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       day['day']!,
//                       style: TextStyle(
//                         color: isSelected
//                             ? Colors.white
//                             : Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       day['date']!,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: isSelected
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }

//   /// 🔥 Today Card
//   Widget _todayCard(Map shift) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFA467A7),
//             Color(0xFFC28DBD),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("TODAY", style: TextStyle(color: Colors.white70)),
//           SizedBox(height: 10),
//           Text(shift['title'],
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Text(shift['time'], style: TextStyle(color: Colors.white70)),
//           Text(shift['location'],
//               style: TextStyle(color: Colors.white70)),
//         ],
//       ),
//     );
//   }

//   /// 🔥 Shift Card
//   Widget _shiftCard(Map shift) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 10,
//             height: 50,
//             color: Color(0xFFA467A7),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(shift['title'],
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(shift['location']),
//               ],
//             ),
//           ),
//           Text(shift['time']),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/ScheduleController.dart';
import 'package:my_app/controller/SwapController.dart';
import 'package:my_app/view/SwapView.dart';

class ScheduleView extends StatelessWidget {
  final controller = Get.put(ScheduleController());

  ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            _header(),

            _viewToggle(),

            _searchBar(),

            _filterChips(),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                var data = controller.filteredShifts;

                if (data.isEmpty) {
                  return _emptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _shiftCard(data[index]);
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 Header
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text("Schedule",
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.calendar_today, color: Color(0xFFA467A7))
        ],
      ),
    );
  }

  /// 🔥 Toggle
  Widget _viewToggle() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: Text("My"),
              selected: controller.showOnlyMine.value,
              onSelected: (_) => controller.toggleView(true),
            ),
            SizedBox(width: 10),
            ChoiceChip(
              label: Text("All"),
              selected: !controller.showOnlyMine.value,
              onSelected: (_) => controller.toggleView(false),
            ),
          ],
        ));
  }

  /// 🔍 Search
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        onChanged: controller.search,
        decoration: InputDecoration(
          hintText: "Search supervisor...",
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  /// 🎯 Chips Filters
  Widget _filterChips() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["All", "Hospital", "Dorm A"]
                .map((loc) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        label: Text(loc),
                        selected:
                            controller.selectedLocation.value == loc,
                        onSelected: (_) =>
                            controller.selectedLocation.value = loc,
                      ),
                    ))
                .toList(),
          ),
        ));
  }

 
/// 🔥 Card
Widget _shiftCard(Map shift) {
  /// 🔥 تحقق هل الشفت إلي ولا لا
  final controller = Get.find<ScheduleController>();
  bool isMine = shift['supervisor'] == controller.myName;

  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 Title + Status
        Row(
          children: [
            Text(
              shift['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Spacer(),
            _statusBadge(shift['status']),
          ],
        ),

        SizedBox(height: 8),

        /// 👩‍⚕️ Supervisor
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Color(0xFFA467A7),
              child: Text(
                shift['supervisor'][0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Text(
              shift['supervisor'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),

        SizedBox(height: 8),

        /// 📍 Location + Time
        Text(
          "${shift['location']} • ${shift['time']}",
          style: TextStyle(color: Colors.grey[700]),
        ),

        SizedBox(height: 12),

        /// 🔁 Swap Action
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: Icon(
              Icons.swap_horiz,
              color: isMine ? Color(0xFFA467A7) : Colors.grey,
            ),
            label: Text(
              isMine ? "Request Swap" : "Not your shift",
              style: TextStyle(
                color: isMine ? Color(0xFFA467A7) : Colors.grey,
              ),
            ),

            /// 🔥 أهم تعديل
            onPressed: isMine
                ? () {
                    final swapController =
                        Get.put(SwapController());

                    swapController.setMyShift(shift);

                    Get.to(() => SwapView());
                  }
                : null,
          ),
        ),
      ],
    ),
  );
}

  /// 🎨 Status Badge
  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "assigned":
        color = Colors.green;
        break;
      case "pending":
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status, style: TextStyle(color: color)),
    );
  }

  /// 🧠 Empty State
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No shifts found"),
        ],
      ),
    );
  }
}