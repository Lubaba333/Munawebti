import 'package:flutter/material.dart';
import '../../../utlis/app_colors.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.darkPurple),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}