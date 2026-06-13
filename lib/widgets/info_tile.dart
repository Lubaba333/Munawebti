import 'package:flutter/material.dart';
import 'package:supervisors/const/app_colors.dart';


class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      color: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Row(
          children: [

            if (icon != null)
              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: AppColors.light
                      .withOpacity(0.2),

                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  icon,
                  color:
                  AppColors.primary,
                ),
              ),

            if (icon != null)
              const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}