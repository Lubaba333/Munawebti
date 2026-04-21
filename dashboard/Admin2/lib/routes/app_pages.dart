import 'package:admin2/view/ScheduleEditorScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../view/CreateProgram.dart';
import '../view/HousingScreen.dart';
import '../view/SplashPage.dart';
import '../view/LoginPage.dart';

import '../view/dashboard_view.dart';
import '../widgets/dashboard_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => AdminLoginView(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleEditorScreen(),
    ),
    GetPage(
      name: AppRoutes.program,
      page: () => CreateScheduleView(),
    ),

  GetPage(
  name: '/buildings',
  page: () => BuildingsScreen(),
  ),

    GetPage(
      name: '/rooms',
      page: () => RoomsScreen(building: Get.arguments),
      customTransition: DepthEnterTransition(),
      transitionDuration: const Duration(milliseconds: 450),
    ),

  GetPage(
  name: '/roomDetails',
  page: () => RoomDetailsScreen(room: Get.arguments),
  transition: Transition.noTransition,
    customTransition: DepthEnterTransition(),
  transitionDuration: const Duration(milliseconds: 600),
  ),

  ];

}
class DepthEnterTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final curved = Curves.easeOutCubic.transform(animation.value);

    return Opacity(
      opacity: curved,
      child: Transform.scale(
        scale: 0.85 + (curved * 0.15), // يبدأ صغير ثم يكبر
        child: Transform.translate(
          offset: Offset(0, (1 - curved) * 30), // نزول خفيف
          child: child,
        ),
      ),
    );
  }
}