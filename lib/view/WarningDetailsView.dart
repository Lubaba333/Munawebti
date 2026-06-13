import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/WarningDetailsController.dart';

class WarningDetailsView
    extends StatelessWidget {

  WarningDetailsView({super.key});

  final controller =
  Get.put(
    WarningDetailsController(),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(
        title:
        const Text("تفاصيل التحذير"),
        centerTitle: true,

      ),

      body: Obx(() {

        if (controller.loading.value) {
          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        final warning =
            controller.warning.value;

        if (warning == null) {
          return const Center(
            child:
            Text("لا توجد بيانات"),
          );
        }

        return ListView(

          padding:
          const EdgeInsets.all(20),

          children: [

            _infoCard(
              "العنوان",
              warning.title,
            ),

            _infoCard(
              "الوصف",
              warning.description,
            ),

            _infoCard(
              "تاريخ التحذير",
              warning.warningDate,
            ),

            _infoCard(
              "العقوبة المحتملة",
              warning.possiblePenalty,
            ),
          ],
        );
      }),
    );
  }

  Widget _infoCard(
      String title,
      String value,
      ) {
    return Card(
    color:
      AppColors.primary,
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(16),

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
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(value),
          ],
        ),
      ),
    );
  }
}