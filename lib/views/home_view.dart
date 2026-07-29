import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/controllers/notification_controller%20.dart';
import 'package:studants/controllers/profile_controller.dart';
import 'package:studants/utlis/app_colors.dart';
import 'package:studants/views/housing_complaints_view.dart';
import 'package:studants/views/lecture_attendance_detail_view.dart';

import 'package:studants/views/rewards_view.dart';
import 'package:studants/views/violations_view.dart';
import 'package:studants/views/warnings_view.dart';
import 'package:studants/widgets/widgets_home/main_card.dart';
import 'package:studants/widgets/widgets_home/service_item.dart';
import 'package:studants/widgets/widgets_home/top_bar.dart';
import '../controllers/home_controller.dart';

// 🔥 الزاوية الداخلية المراد قصّها من كل كارد (الزاوية المواجهة لمركز الشبكة)
enum _NotchCorner { topLeft, topRight, bottomLeft, bottomRight }

// 🔥 Clipper مخصص: يرسم شكل الكارد بزوايا مدورة عادية على 3 أطراف،
// وقص مقعّر (نصف قطره = نصف قطر الدائرة) على الزاوية الداخلية
class _NotchedCardClipper extends CustomClipper<Path> {
  final double cardRadius;
  final double notchRadius;
  final _NotchCorner notchCorner;

  _NotchedCardClipper({
    required this.cardRadius,
    required this.notchRadius,
    required this.notchCorner,
  });

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final double tl = notchCorner == _NotchCorner.topLeft ? notchRadius : cardRadius;
    final double tr = notchCorner == _NotchCorner.topRight ? notchRadius : cardRadius;
    final double br = notchCorner == _NotchCorner.bottomRight ? notchRadius : cardRadius;
    final double bl = notchCorner == _NotchCorner.bottomLeft ? notchRadius : cardRadius;

    final path = Path();
    path.moveTo(tl, 0);
    path.lineTo(w - tr, 0);

    // الزاوية العلوية اليمنى
    if (notchCorner == _NotchCorner.topRight) {
      path.arcTo(Rect.fromCircle(center: Offset(w, 0), radius: tr), pi, -pi / 2, false);
    } else {
      path.arcTo(Rect.fromCircle(center: Offset(w - tr, tr), radius: tr), -pi / 2, pi / 2, false);
    }

    path.lineTo(w, h - br);

    // الزاوية السفلية اليمنى
    if (notchCorner == _NotchCorner.bottomRight) {
      path.arcTo(Rect.fromCircle(center: Offset(w, h), radius: br), -pi / 2, -pi / 2, false);
    } else {
      path.arcTo(Rect.fromCircle(center: Offset(w - br, h - br), radius: br), 0, pi / 2, false);
    }

    path.lineTo(bl, h);

    // الزاوية السفلية اليسرى
    if (notchCorner == _NotchCorner.bottomLeft) {
      path.arcTo(Rect.fromCircle(center: Offset(0, h), radius: bl), 0, -pi / 2, false);
    } else {
      path.arcTo(Rect.fromCircle(center: Offset(bl, h - bl), radius: bl), pi / 2, pi / 2, false);
    }

    path.lineTo(0, tl);

    // الزاوية العلوية اليسرى
    if (notchCorner == _NotchCorner.topLeft) {
      path.arcTo(Rect.fromCircle(center: Offset(0, 0), radius: tl), pi / 2, -pi / 2, false);
    } else {
      path.arcTo(Rect.fromCircle(center: Offset(tl, tl), radius: tl), pi, pi / 2, false);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _NotchedCardClipper oldClipper) {
    return oldClipper.notchCorner != notchCorner ||
        oldClipper.cardRadius != cardRadius ||
        oldClipper.notchRadius != notchRadius;
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin, WidgetsBindingObserver {
  final HomeController controller = Get.put(HomeController());
  final profileController = Get.put(ProfileController());

  late AnimationController animController;
  late AnimationController entryController;

  final Random _random = Random();
  final List<Offset> _randomOffsets = [];

  // 🔥 مؤقّت التحديث التلقائي الدوري
  Timer? _autoRefreshTimer;
  static const Duration _autoRefreshInterval = Duration(seconds: 30);

  // 🔥 قياسات ثابتة تتحكم بشكل الدائرة والقص — عدّليهم هون لو بدك تكبري/تصغري
  static const double _circleDiameter = 117;
  static const double _cardCornerRadius = 18; // نفس قيمة الزوايا بـ ServiceItem
  static const double _gridSpacing = 12; // 🔥 المسافة بين الكاردات — زيديها/نقصيها زي ما بدك
  static const double _circleGap = 13; // 🔥 الفراغ المطلوب بين حدود الدائرة وحواف القصّة
  // 🔥 نصف قطر القصّة = نصف قطر الدائرة + الفراغ المطلوب - نص المسافة بين الكاردات
  static const double _notchRadius =
      (_circleDiameter / 2) + _circleGap - (_gridSpacing / 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    _generateRandomOffsets(20);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        entryController.forward();
      }
    });

    // 🔥 تشغيل التحديث التلقائي الدوري (كل 30 ثانية)
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (_) {
      _refreshHome();
    });
  }

  // ✅ عند الرجوع للتطبيق من الخلفية → تحديث فوري لكل شي بالهوم
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _refreshHome();
    }
  }

  // 🔥 الدالة المركزية للتحديث — كل عناصر الهوم (المين كارد + الإشعارات) بتتحدث من هون
  Future<void> _refreshHome() async {
    await Future.wait([
      controller.loadNextLecture(), // 👈 تحديث بيانات المحاضرة القادمة (المين كارد)
      if (Get.isRegistered<NotificationController>())
        Get.find<NotificationController>().getNotifications(),
      // 🔥 لو عندك دالة تحديث بروفايل الطالبة بالـ ProfileController، فعّلي السطر التالي:
       profileController.getProfile(),
    ]);
  }

  void _generateRandomOffsets(int count) {
    _randomOffsets.clear();

    for (int i = 0; i < count; i++) {
      final dx = (_random.nextBool() ? 1 : -1) * (70 + _random.nextInt(110)).toDouble();
      final dy = (_random.nextBool() ? 1 : -1) * (45 + _random.nextInt(120)).toDouble();
      _randomOffsets.add(Offset(dx, dy));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animController.dispose();
    entryController.dispose();
    _autoRefreshTimer?.cancel(); // 🔥 إيقاف المؤقّت عند إغلاق الشاشة
    super.dispose();
  }

  Animation<double> _animationFor(int index) {
    final double start = (index * 0.06).clamp(0.0, 0.70);
    final double end = (start + 0.45).clamp(0.0, 1.0);

    return CurvedAnimation(
      parent: entryController,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _randomEntry({
    required int index,
    required Widget child,
  }) {
    final Offset offset = index < _randomOffsets.length ? _randomOffsets[index] : Offset.zero;

    return AnimatedBuilder(
      animation: entryController,
      child: child,
      builder: (context, child) {
        final animation = _animationFor(index);
        final value = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1 - value),
              offset.dy * (1 - value),
            ),
            child: Transform.scale(
              scale: 0.88 + (0.12 * value),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // 🔥 يلف أي ServiceItem بقصّة الزاوية الداخلية المناسبة
  Widget _notchedServiceItem({
    required Widget child,
    required _NotchCorner notchCorner,
  }) {
    return ClipPath(
      clipper: _NotchedCardClipper(
        cardRadius: _cardCornerRadius,
        notchRadius: _notchRadius,
        notchCorner: notchCorner,
      ),
      child: child,
    );
  }

  // ⚠️ الترتيب البصري بالتطبيق (RTL): تنبيهاتي أعلى-يمين / مكافآتي أعلى-يسار
  // مخالفاتي أسفل-يسار / شكوى السكن أسفل-يمين — لذلك الزاوية الداخلية لكل
  // كارد محسوبة حسب موضعه الفعلي على الشاشة وليس ترتيبه بالقائمة.
  List<Widget> _services() {
    return [
      // تنبيهاتي — أعلى اليمين → الزاوية الداخلية: أسفل اليسار
      _randomEntry(
        index: 5,
        child: _notchedServiceItem(
          notchCorner: _NotchCorner.bottomLeft,
          child: ServiceItem(
            icon: Icons.warning_amber_rounded,
            title: "warnings".tr,
            onTap: () => Get.to(() => WarningsView()),
          ),
        ),
      ),
      // مكافآتي — أعلى اليسار → الزاوية الداخلية: أسفل اليمين
      _randomEntry(
        index: 6,
        child: _notchedServiceItem(
          notchCorner: _NotchCorner.bottomRight,
          child: ServiceItem(
            icon: Icons.emoji_events,
            title: "rewards".tr,
            onTap: () => Get.to(() => RewardsView()),
          ),
        ),
      ),
      // شكوى السكن — أسفل اليمين → الزاوية الداخلية: أعلى اليسار
      _randomEntry(
        index: 7,
        child: _notchedServiceItem(
          notchCorner: _NotchCorner.topLeft,
          child: ServiceItem(
            icon: Icons.report_problem,
            title: "housing_complaint".tr,
            onTap: () => Get.to(() => HousingComplaintsView()),
          ),
        ),
      ),
      // مخالفاتي — أسفل اليسار → الزاوية الداخلية: أعلى اليمين
      _randomEntry(
        index: 8,
        child: _notchedServiceItem(
          notchCorner: _NotchCorner.topRight,
          child: ServiceItem(
            icon: Icons.gavel,
            title: "violations".tr,
            onTap: () => Get.to(() => ViolationsView()),
          ),
        ),
      ),
    ];
  }

  // 🔥 الدائرة الوسطى — بنفس ستايل ولون كاردات ServiceItem بالضبط (بدون بنفسجي)
  Widget _attendanceFloatingCircle(BuildContext context) {
    final isDark = Get.isDarkMode;

    return _randomEntry(
      index: 10,
      child: GestureDetector(
        onTap: () => Get.to(() => LectureAttendanceView()),
        child: Container(
          width: _circleDiameter,
          height: _circleDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Theme.of(context).cardColor,
                      Colors.white.withOpacity(.05),
                    ]
                  : const [
                      Colors.white,
                      AppColors.softLavender,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDark
                  ? AppColors.mauve.withOpacity(.18)
                  : AppColors.mauve.withOpacity(.10),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(.20)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fact_check_rounded,
                color: isDark ? AppColors.mauve : AppColors.darkPurple,
                size: 26,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "تسجيل الحضور",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        // 🔥 سحب للتحديث اليدوي — بينادي نفس دالة التحديث المركزية
        child: RefreshIndicator(
          onRefresh: _refreshHome,
          color: AppColors.darkPurple,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _randomEntry(index: 0, child: const TopBar()),
                _randomEntry(
                  index: 2,
                  child: Obx(
                    () => Center(
                      child: Text(
                        profileController.name.value.isEmpty
                            ? "student".tr
                            : profileController.name.value,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _randomEntry(index: 3, child: MainCard(animController: animController)),
                const SizedBox(height: 30),
                _randomEntry(
                  index: 4,
                  child: Text(
                    "services".tr,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 🔥 الشبكة (4 كاردات مقصوصة من زاويتها الداخلية) + الدائرة بالمنتصف بالضبط
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: _gridSpacing,
                      mainAxisSpacing: _gridSpacing,
                      childAspectRatio: 1.1,
                      children: _services(),
                    ),
                    _attendanceFloatingCircle(context),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}