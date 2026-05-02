import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/SwapController.dart';


class SwapView extends StatelessWidget {
  final controller = Get.put(SwapController());

  SwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swap Shift"),
        backgroundColor: Color(0xFFA467A7),
      ),
      body: Column(
        children: [

          /// 🔥 My Shift
          _myShiftCard(),

          /// 🔥 Available
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Available Shifts",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: controller.availableShifts.length,
                itemBuilder: (context, index) {
                  final shift =
                      controller.availableShifts[index];

                  return _shiftOption(shift);
                },
              );
            }),
          ),

          /// 🔥 Submit Button
          _submitButton()
        ],
      ),
    );
  }

  /// 💜 My Shift Card
  Widget _myShiftCard() {
    return Obx(() {
      var shift = controller.myShift;

      return Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA467A7),
              Color(0xFFC28DBD),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Shift",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text(shift['title'] ?? "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(shift['time'] ?? "",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    });
  }

  /// 🔥 Option Card
  Widget _shiftOption(Map shift) {
    return Obx(() {
      bool isSelected =
          controller.selectedShift.value == shift;

      return GestureDetector(
        onTap: () => controller.selectShift(shift),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFFA467A7).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? Color(0xFFA467A7)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(shift['supervisor'][0]),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(shift['supervisor'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                    Text(shift['location']),
                  ],
                ),
              ),
              Text(shift['time'])
            ],
          ),
        ),
      );
    });
  }

  /// 🚀 Submit
  Widget _submitButton() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA467A7),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: controller.isSubmitting.value
                ? null
                : controller.submitRequest,
            child: controller.isSubmitting.value
                ? CircularProgressIndicator(
                    color: Colors.white)
                : Center(
                    child: Text("Send Request",
                        style:
                            TextStyle(color: Colors.white)),
                  ),
          ),
        ));
  }
}