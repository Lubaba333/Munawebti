import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_details_controller.dart';
import '../utlis/app_colors.dart';

class RewardDetailsView extends StatelessWidget {
  final int id;

  const RewardDetailsView({super.key, required this.id});

  static const rewardGold = Color(0xFFFFB300);

  String _text(dynamic value) {
    if (value == null) return "not_specified".tr;
    if (value.toString().isEmpty) return "not_specified".tr;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RewardDetailsController(id),
      tag: id.toString(),
    );

    return Scaffold(
      backgroundColor: AppColors.softLavender,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mauve,
                        ),
                      );
                    }

                    final r = controller.reward;

                    if (r.isEmpty) {
                      return Center(
                        child: Text("no_details".tr),
                      );
                    }

                    final creator = r['creator'];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _certificateHeader(r),
                          const SizedBox(height: 22),
                          _certificateItem(
                            icon: Icons.description_outlined,
                            title: "description".tr,
                            value: _text(r['description']),
                          ),
                          _certificateItem(
                            icon: Icons.calendar_month_rounded,
                            title: "reward_date".tr,
                            value: _text(r['created_at']),
                          ),
                          _certificateItem(
                            icon: Icons.person_rounded,
                            title: "supervisor".tr,
                            value: creator is Map
                                ? _text(creator['full_name'])
                                : "not_specified".tr,
                            showDivider: false,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFFFD54F),
              size: 31,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "reward_details".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "view_full_reward_info".tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _certificateHeader(Map r) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: rewardGold.withOpacity(.13),
            shape: BoxShape.circle,
            border: Border.all(
              color: rewardGold.withOpacity(.30),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: rewardGold,
            size: 52,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "official_reward".tr,
          style: const TextStyle(
            color: AppColors.darkPurple,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _text(r['title']),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.darkPurple,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  Widget _certificateItem({
    required IconData icon,
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: rewardGold,
                size: 23,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}