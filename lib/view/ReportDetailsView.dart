import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/ReportDetailsController.dart';


class ReportDetailsView
    extends StatelessWidget {

  ReportDetailsView({
    super.key,
  });

  final controller =
  Get.put(
    ReportDetailsController(),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "تفاصيل التقرير",
        ),
      ),

      body: Obx(() {

        if (controller.loading.value) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        final report =
            controller.report.value;

        if (report == null) {

          return const Center(
            child: Text(
              "لا يوجد بيانات",
            ),
          );
        }

        return Padding(
          padding:
          const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const Text(
                "ملاحظات التقرير",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                report.notes,
                style:
                const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                report.createdAt
                    .split('T')
                    .first,
              ),
            ],
          ),
        );
      }),
    );
  }
}