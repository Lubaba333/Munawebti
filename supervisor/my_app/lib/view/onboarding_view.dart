import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/const/app_colors.dart';
import 'package:my_app/controller/onboarding_controller.dart';
import 'package:my_app/view/LoginView.dart';

class OnboardingView extends StatelessWidget {
  final controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      "image": "assets/on1.png",
      "title": "Manage Students Easily",
      "desc":
          "Track and manage nursing students efficiently in school and housing."
    },
    {
      "image": "assets/on2.png",
      "title": "Organize Schedules",
      "desc":
          "Easily manage supervisors shifts and student schedules."
    },
    {
      "image": "assets/on3.png",
      "title": "Hospital Training Tracking",
      "desc":
          "Monitor students training and progress in hospitals in real-time."
    },
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            /// 🔹 Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Align(
                alignment: Alignment.topRight,
                child: Obx(() => AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: controller.currentPage.value == pages.length - 1 ? 0 : 1,
                      child: GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(pages.length - 1);
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )),
              ),
            ),

            /// 🔹 Pages
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: controller.changePage,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),

            /// 🔻 Bottom Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: Column(
                children: [

                  /// 🔹 Dots
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: controller.currentPage.value == index ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )),

                  SizedBox(height: 50),

                  /// 🔹 Back + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      /// 🔹 Back
                      Obx(() => AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: controller.currentPage.value == 0 ? 0 : 1,
                            child: GestureDetector(
                              onTap: () {
                                pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )),

                      /// 🔹 Next / Get Started
                      Obx(() {
                        bool isLast =
                            controller.currentPage.value == pages.length - 1;

                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 400),
                          child: isLast 
                              ? GestureDetector(
                                  key: ValueKey("start"),
                                  onTap: () {
                                   Get.off(() => LoginView()
                                   );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 15,
                                        )
                                      ],
                                    ),
                                  
                                    child: Text(
                                      "Get started",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : GradientTrailButton(
                                  onTap: () {
                                    pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                        );
                      })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔹 Page UI
  Widget _buildPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// Image Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1),
            duration: Duration(milliseconds: 500),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Image.asset(
              data["image"]!,
              height: 250,
            ),
          ),

          SizedBox(height: 40),

          Text(
            data["title"]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 10),

          Text(
            data["desc"]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
class GradientTrailButton extends StatelessWidget {
  final VoidCallback onTap;

  const GradientTrailButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 70,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [

          // /// 🔥 Trail رئيسي (ممتد وناعم)
          Container(
            width: 100,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.35),
                  AppColors.secondary.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),

          /// 🔥 Glow ناعم حول الزر
          Positioned(
            right: 0,
            child: Container(
              width: 82,
              height: 67,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
            ),
          ),
          ////
             Positioned(
            right: 0,
            child: Container(
              width: 73,
              height: 61,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
            ),
          ),

          /// 🔥 الزر الأساسي (ملتصق بالذيل)
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 60,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}