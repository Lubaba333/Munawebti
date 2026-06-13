import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/RewardDetailsController.dart';


class RewardDetailsView
    extends StatelessWidget {

  RewardDetailsView({super.key});

  final controller =
  Get.put(
    RewardDetailsController(),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "تفاصيل المكافأة",
        ),
      ),

      body: Obx(() {

        if (controller.loading.value) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        final reward =
            controller.reward.value;

        if (reward == null) {

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

              Text(
                reward.title,
                style:
                const TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                reward.description,
                style:
                const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                reward.createdAt
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