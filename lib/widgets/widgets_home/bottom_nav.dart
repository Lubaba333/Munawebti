import 'package:flutter/material.dart';
import '../../../utlis/app_colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: AppColors.darkPurple),
            Icon(Icons.calendar_month, color: Colors.grey),
            Icon(Icons.notifications, color: Colors.grey),
            Icon(Icons.person, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}