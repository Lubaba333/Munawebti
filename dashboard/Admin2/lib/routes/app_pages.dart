import 'package:admin2/view/ScheduleEditorScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/DashboardController.dart';
import '../controller/UserManagement_controller.dart';
import '../view/CreateProgram.dart';
import '../view/RoomStudentsView.dart';
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
      binding: BindingsBuilder(() {
        Get.put(DashboardController());
        Get.put(UserManagementController());
      }),
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
      name: '/room-details',
      page: () => RoomDetailsView(),
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