import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../routes/app_routes.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController waveController;
  late AnimationController heartPulseController; // متحكم النبض المستمر

  late AnimationController logoController;
  late Animation<double> logoScale;

  final Random random = Random();
  final List<_ParticleData> particles = [];

  @override
  void initState() {
    super.initState();

    // 1. أنيميشن الانتشار (مرة واحدة عند البداية)
    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    // 2. أنيميشن النبض (يتكرر للأبد)
    heartPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // 3. أنيميشن اللوغو
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );
    logoController.forward();

    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < 25; i++) { // زيادة عدد العناصر قليلاً
      double angle = random.nextDouble() * 2 * pi;
      double maxDistance = 200 + random.nextDouble() * 300;

      particles.add(_ParticleData(
        angle: angle,
        distance: maxDistance,
        // تكبير الأحجام لتكون أوضح (بين 40 و 70)
        size: 40 + random.nextDouble() * 30,
        icon: random.nextBool() ? Icons.favorite : Icons.medical_services,
        delay: random.nextDouble() * 0.6,
      ));
    }
  }

  @override
  void dispose() {
    waveController.dispose();
    heartPulseController.dispose();
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD59EFA), Color(0xFF5A0891)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // العناصر المنتشرة والنابضة
            ...particles.map((p) => AnimatedBuilder(
              animation: Listenable.merge([waveController, heartPulseController]),
              builder: (context, child) {
                double progress = (waveController.value - p.delay).clamp(0.0, 1.0);

                // حساب المسافة الموجية
                double currentDist = Curves.easeOutCubic.transform(progress) * p.distance;
                double dx = center.dx + cos(p.angle) * currentDist - (p.size / 2);
                double dy = center.dy + sin(p.angle) * currentDist - (p.size / 2);

                // حساب تأثير النبض (فقط للقلوب أو للكل حسب رغبتك)
                // النبض يتراوح بين 0.8 و 1.3 من الحجم الأصلي
                double pulse = 1.0 + (heartPulseController.value * 0.3);

                return Positioned(
                  left: dx,
                  top: dy,
                  child: Opacity(
                    opacity: progress > 0 ? (1.0 - progress).clamp(0.1, 0.7) : 0,
                    child: Transform.scale(
                      // نضرب حجم الانتشار في حجم النبض
                      scale: progress * pulse,
                      child: Icon(
                          p.icon,
                          color: Colors.white.withOpacity(0.8),
                          size: p.size
                      ),
                    ),
                  ),
                );
              },
            )),

            // اللوغو
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.login),
                child: ScaleTransition(
                  scale: logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 20),
                      const Text(
                        "MUNAWEBTI",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 10)]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 25, spreadRadius: 2)],
        image: const DecorationImage(image: AssetImage("assets/images/logoo.jpg"), fit: BoxFit.cover),
      ),
    );
  }
}

class _ParticleData {
  final double angle;
  final double distance;
  final double size;
  final IconData icon;
  final double delay;

  _ParticleData({
    required this.angle,
    required this.distance,
    required this.size,
    required this.icon,
    required this.delay,
  });
}