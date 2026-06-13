import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reward_controller.dart';
import '../utlis/app_colors.dart';
import 'reward_details_view.dart';

class RewardsView extends StatefulWidget {
  RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(RewardController());

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _fade = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(38),
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

                    if (controller.rewards.isEmpty) {
                      return _emptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                      itemCount: controller.rewards.length,
                      itemBuilder: (context, index) {
                        final r = controller.rewards[index];

                        return FadeTransition(
                          opacity: _fade,
                          child: SlideTransition(
                            position: _slide,
                            child: _buildRewardCard(r, index),
                          ),
                        );
                      },
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
    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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
            const SizedBox(width: 14),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade300,
                    Colors.orange.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مكافآتي",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "إنجازاتك الذهبية في مكان واحد",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
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

  Widget _emptyState() {
    return FadeTransition(
      opacity: _fade,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade200,
                    Colors.orange.shade200,
                  ],
                ),
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 58,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "لا توجد مكافآت بعد",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "عند حصولك على مكافأة ستظهر هنا ✨",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildRewardCard(dynamic r, int index) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFFF8E1),
          Colors.amber.shade100,
          Colors.white,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: Colors.amber.withOpacity(.45),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.amber.withOpacity(.22),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: -18,
          top: -18,
          child: Icon(
            Icons.star_rounded,
            size: 95,
            color: Colors.amber.withOpacity(.15),
          ),
        ),
        Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade500,
                    Colors.orange.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(.35),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "REWARD",
        style: TextStyle(
          color: Color(0xFF9A6A00),
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          letterSpacing: .8,
        ),
      ),
    ),

    const Spacer(),

    TextButton.icon(
      onPressed: () {
        Get.to(() => RewardDetailsView(id: r.id));
      },
      icon: const Icon(
        Icons.visibility_outlined,
        size: 16,
      ),
      label: const Text("تفاصيل"),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPurple,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  ],
),

const SizedBox(height: 8),

Text(
  r.title,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    color: AppColors.darkPurple,
    fontSize: 17,
    fontWeight: FontWeight.bold,
    height: 1.25,
  ),
),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.grey.shade600,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          r.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
              
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}