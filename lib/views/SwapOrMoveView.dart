import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/MoveRoomView.dart';

import 'swap_view.dart';


class SwapOrMoveView extends StatelessWidget {
  const SwapOrMoveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                const Text(
                  "نقل الغرفة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                _ChoiceCard(
                  title: "تبديل غرفة",
                  subtitle: "تبديل بين طالبتين",
                  icon: Icons.swap_horiz,
                  color: Colors.purpleAccent,
                  onTap: () {
                    Get.to(() => const SwapView(),
                        transition: Transition.zoom);
                  },
                ),

                const SizedBox(height: 25),

                _ChoiceCard(
                  title: "نقل غرفة",
                  subtitle: "نقل طالبة إلى غرفة جديدة",
                  icon: Icons.meeting_room,
                  color: Colors.orangeAccent,
                  onTap: () {
                    Get.to(() => const MoveRoomView(),
                        transition: Transition.zoom);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.3),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}