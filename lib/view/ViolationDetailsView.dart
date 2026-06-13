import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/ViolationDetailsController.dart';

class ViolationDetailsView
    extends StatelessWidget {

  ViolationDetailsView({
    super.key,
  });

  final controller = Get.put(
    ViolationDetailsController(),
  );

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(
        title:
        const Text(
          "تفاصيل المخالفة",
        ),
        backgroundColor:
        AppColors.primary,
      ),

      body: Obx(() {

        if (controller.loading.value) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        final violation =
            controller
                .violation
                .value;

        if (violation == null) {

          return const Center(
            child:
            Text(
              "لا توجد بيانات",
            ),
          );
        }

        return ListView(
          padding:
          const EdgeInsets.all(
              16),

          children: [

            Card(
              child: ListTile(
                title:
                const Text(
                  "العنوان",
                ),
                subtitle:
                Text(
                  violation.title,
                ),
              ),
            ),

            Card(
              child: ListTile(
                title:
                const Text(
                  "الوصف",
                ),
                subtitle:
                Text(
                  violation
                      .description,
                ),
              ),
            ),

            Card(
              child: ListTile(
                title:
                const Text(
                  "التصنيف",
                ),
                subtitle:
                Text(
                  violation
                      .category,
                ),
              ),
            ),

            Card(
              child: ListTile(
                title:
                const Text(
                  "العقوبة",
                ),
                subtitle:
                Text(
                  violation
                      .penalty,
                ),
              ),
            ),

            Card(
              child: ListTile(
                title:
                const Text(
                  "التاريخ",
                ),
                subtitle:
                Text(
                  violation
                      .violationDate,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}