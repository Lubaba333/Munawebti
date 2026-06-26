import 'package:flutter/material.dart';
import 'package:supervisors/const/app_colors.dart';


class StudentActivityCard extends StatelessWidget {

  final String title;
  final String description;
  final String date;
  final IconData icon;
  final VoidCallback? onTap;

  const StudentActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(16),

        onTap: onTap,

        child: Padding(
          padding:
          const EdgeInsets.all(16),

          child: Row(
            children: [

              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withOpacity(0.1),

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

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      description,
                      style:
                      TextStyle(
                        color:
                        Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}