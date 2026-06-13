import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_details_controller.dart';
import '../utlis/app_colors.dart';

class RewardDetailsView extends StatefulWidget {
  final int id;

  const RewardDetailsView({super.key, required this.id});

  @override
  State<RewardDetailsView> createState() => _RewardDetailsViewState();
}

class _RewardDetailsViewState extends State<RewardDetailsView> {
  late final RewardDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RewardDetailsController(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FB),
      appBar: AppBar(
        title: const Text("تفاصيل المكافأة"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkPurple,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mauve),
          );
        }

        if (controller.reward.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final r = controller.reward;

        return Stack(
          children: [
            _background(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _rewardHeader(r['title'] ?? ''),
                  const SizedBox(height: 18),
                  _goldRewardCard(r['title'] ?? ''),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      _item(
                        title: "Description",
                        value: r['description'],
                        icon: Icons.description_outlined,
                      ),
                      _item(
                        title: "Date",
                        value: r['created_at'],
                        icon: Icons.calendar_month_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _rewardHeader(String title) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.85),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepPurple.withOpacity(.08),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFB300),
            size: 32,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            "أحسنتِ! هذه مكافأتك",
            style: TextStyle(
              color: AppColors.darkPurple,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _goldRewardCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFFB300),
            Color(0xFFFFF3C4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withOpacity(.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -24,
            child: Icon(
              Icons.star_rounded,
              size: 120,
              color: Colors.white.withOpacity(.20),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -18,
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 90,
              color: Colors.white.withOpacity(.18),
            ),
          ),
          Column(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.32),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(.55),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "REWARD",
                style: TextStyle(
                  color: Color(0xFF7A5200),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required dynamic value,
    required IconData icon,
  }) {
    if (value == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mauve.withOpacity(.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPurple.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.softLavender,
            child: Icon(
              icon,
              color: AppColors.darkPurple,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _circle(200, AppColors.lightPink.withOpacity(0.45)),
        ),
        Positioned(
          top: 160,
          right: -70,
          child: _circle(190, AppColors.mauve.withOpacity(0.30)),
        ),
        Positioned(
          bottom: -90,
          left: 50,
          child: _circle(230, const Color(0xFFFFD54F).withOpacity(0.25)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}