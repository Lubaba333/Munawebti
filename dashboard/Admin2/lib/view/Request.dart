import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/RequestController.dart';
import '../widgets/AppColors.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(RequestController());

  final Gradient headerGradient = const LinearGradient(
    colors: [Color(0xFF5A0891), Color(0xFF8E2DE2)],
  );

  /// 🔥 ANIMATION CONTROLLER FOR FILTER SWITCH
  late AnimationController filterAnim;

  @override
  void initState() {
    super.initState();

    filterAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void triggerFilterAnim() {
    filterAnim.forward(from: 0);
  }

  @override
  void dispose() {
    filterAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(gradient: headerGradient),
          child:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Request Management",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [

          /// 🔥 FILTER + SORT (WITH ANIMATION)
          Obx(() => Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [

                /// FILTER
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        "all",
                        "pending",
                        "approved",
                        "rejected",
                        "escalated"
                      ].map((filter) {
                        final isSelected =
                            controller.selectedFilter.value == filter;

                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedFilter.value = filter;
                              triggerFilterAnim(); // 🔥 animation trigger
                            },
                            child: AnimatedScale(
                              duration:
                              const Duration(milliseconds: 200),
                              scale: isSelected ? 1.1 : 1.0,
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                selectedColor: AppColors.primary,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// SORT
                DropdownButton<String>(
                  value: controller.sortType.value,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: "newest", child: Text("Newest")),
                    DropdownMenuItem(
                        value: "oldest", child: Text("Oldest")),
                  ],
                  onChanged: (v) => controller.sortType.value = v!,
                ),
              ],
            ),
          )),

          /// 🔥 GRID
          Expanded(
            child: Obx(() {
              final list = controller.filteredRequests;

              if (list.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No requests found"),
                    ],
                  ),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: GridView.builder(
                  key: ValueKey(controller.selectedFilter.value), // 🔥 مهم
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, index) {
                    final request = list[index];

                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 900 + index * 120),
                      curve: Curves.easeOutCubic,
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) {
                        // مرحلة دخول + ارتداد بسيط + تثبيت
                        final double bounce = Curves.elasticOut.transform(value);

                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              (1 - value) * 200,   // دخول من اليمين
                              (1 - value) * 160,   // دخول من تحت
                            ),
                            child: Transform.scale(
                              scale: 0.85 + (bounce * 0.15), // 👈 يعطي “نبضة” ثم يثبت
                              child: child,
                            ),
                          ),
                        );
                      },
                      onEnd: () {

                      },
                      child: _card(request, index),
                    );
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  /// 💎 CARD
  Widget _card(Request request, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: _statusColor(request.status),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            request.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              request.type,
              style: const TextStyle(fontSize: 10),
            ),
          ),

          const SizedBox(height: 8),

          _status(request.status),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBtn(
                icon: Icons.check,
                color: Colors.green,
                onTap: () => controller.approve(index),
              ),
              _iconBtn(
                icon: Icons.close,
                color: Colors.red,
                onTap: () {
                  Get.defaultDialog(
                    title: "Reject",
                    content: TextField(
                      onSubmitted: (v) {
                        controller.reject(index, v);
                        Get.back();
                      },
                      decoration: const InputDecoration(
                        hintText: "Reason...",
                      ),
                    ),
                  );
                },
              ),
              _iconBtn(
                icon: Icons.edit,
                color: AppColors.primary,
                onTap: () {
                  Get.toNamed("/schedule");
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 💎 STATUS
  Widget _status(String status) {
    final c = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: c,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "escalated":
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}