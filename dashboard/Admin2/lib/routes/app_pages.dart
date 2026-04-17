import 'package:admin2/view/ScheduleEditorScreen.dart';
import 'package:get/get.dart';
import '../view/CreateProgram.dart';
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
  ];

}