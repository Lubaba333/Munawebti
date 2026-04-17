
import 'package:flutter/material.dart';

import 'AppColors.dart';

class OutlineButtonWidget extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const OutlineButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 45,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),

      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}