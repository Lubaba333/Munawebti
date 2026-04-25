import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/profile_view.dart';
import '../../../utlis/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu, color: AppColors.darkPurple),
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => ProfileView()),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.mauve.withOpacity(0.3),
            child: const Icon(Icons.person, color: AppColors.darkPurple),
          ),
        ),
      ],
    );
  }
}