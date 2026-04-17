import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/AppColors.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [12, 18, 10, 22, 17, 25, 20];
    final requestTypes = [40.0, 30.0, 20.0, 10.0];
    final violations = [5.0, 8.0, 3.0];

    return SingleChildScrollView(
      child: Column(
        children: [

          /// 🔥 TOP STATS
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: AnimatedStatCard(title: "Users", value: 120, icon: Icons.people)),
              SizedBox(width: 15),
              Expanded(child: AnimatedStatCard(title: "Requests", value: 45, icon: Icons.request_page)),
              SizedBox(width: 15),
              Expanded(child: AnimatedStatCard(title: "Violations", value: 8, icon: Icons.warning)),
              SizedBox(width: 15),
              Expanded(child: AnimatedStatCard(title: "Emergencies", value: 2, icon: Icons.emergency)),
            ],
          ),

          const SizedBox(height: 25),

          /// 🔥 CHARTS ROW
          Row(
            children: [
              /// 🔹 Animated Line Chart
              Expanded(
                flex: 2,
                child: _hoverContainer(
                  "Requests This Week",
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOut,
                    builder: (context, t, child) {
                      final animatedSpots = List.generate(
                        requests.length,
                            (i) => FlSpot(i.toDouble(), requests[i] * t),
                      );

                      return SizedBox(
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.black87,
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                barWidth: 4,
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.blue.withOpacity(0.2)],
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                                  ),
                                ),
                                spots: animatedSpots,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 20),

              /// 🔹 Animated Pie Chart
              Expanded(
                child: _hoverContainer(
                  "Request Types",
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOut,
                    builder: (context, t, child) {
                      return SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 50,
                            sections: List.generate(
                              requestTypes.length,
                                  (i) => PieChartSectionData(
                                value: requestTypes[i] * t,
                                color: Colors.primaries[i],
                                radius: 60,
                                title: '${(requestTypes[i] * t).toInt()}',
                                titleStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔥 Animated Bar Chart
          _hoverContainer(
            "Violations Severity",
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOut,
              builder: (context, t, child) {
                return SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black87,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        violations.length,
                            (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: violations[i] * t,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 HOVER CONTAINER
  Widget _hoverContainer(String title, Widget child) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHover = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHover = true),
          onExit: (_) => setState(() => isHover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(isHover ? 1.02 : 1.0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isHover
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isHover ? 20 : 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 🔥 ANIMATED CARD
class AnimatedStatCard extends StatefulWidget {
  final String title;
  final int value;
  final IconData icon;

  const AnimatedStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard> {
  int displayValue = 0;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  void _animate() async {
    for (int i = 0; i <= widget.value; i++) {
      await Future.delayed(const Duration(milliseconds: 15));
      setState(() => displayValue = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        /// 🔥 Glass Effect
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.secondary,
            child: Icon(widget.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "$displayValue",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(widget.title),
          ],
          )
        ],
      ),
    );
  }
}