import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/violation_controller.dart';

class ViolationScreen extends StatelessWidget {
  ViolationScreen({super.key});

  final c = Get.put(ViolationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),

      appBar: AppBar(
        title: const Text("Violation Dashboard"),
        backgroundColor: const Color(0xFF5A0891),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 10),

          // 📊 STATS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Obx(() => _stat("Total", c.total.toString(), Colors.purple)),
                Obx(() => _stat("Critical", c.critical.toString(), Colors.red)),
                _stat("Avg", "78%", Colors.green),
                _stat("Top", "Sara", Colors.blue),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ❌ تم حذف شريط البحث + الفلاتر بالكامل

          // 📄 LIST
          Expanded(
            child: Obx(() {
              final list = c.filtered;

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final v = list[i];
                  return _violationCard(v);
                },
              );
            }),
          ),
        ],
      ),

      // ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5A0891),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  // 📊 STAT CARD
  Widget _stat(String t, String v, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              v,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(t),
          ],
        ),
      ),
    );
  }

  // 📄 VIOLATION CARD
  Widget _violationCard(v) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text(v.user[0]),
        ),

        title: Text(v.user),
        subtitle: Text(v.title),

        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            v.points.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}