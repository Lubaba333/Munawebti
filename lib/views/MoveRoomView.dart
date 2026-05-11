import 'package:flutter/material.dart';

class MoveRoomView extends StatelessWidget {
  const MoveRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نقل غرفة")),
      body: const Center(
        child: Text("هنا واجهة نقل الغرفة"),
      ),
    );
  }
}