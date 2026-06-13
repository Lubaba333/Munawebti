import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studants/views/housing_complaints_creat%20view.dart';
import 'package:studants/widgets/gradient_button.dart';
import '../controllers/housing_complaint_controller.dart';
import '../utlis/app_colors.dart';
import 'housing_complaint_detail_view.dart';


class HousingComplaintsView extends StatelessWidget {
  HousingComplaintsView({super.key});

  final controller = Get.put(HousingComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softLavender,
bottomNavigationBar: SafeArea(
  child: Container(
    color: Colors.white,
    padding: const EdgeInsets.only(
      right: 16,
      left: 16,
      top: 10,
      bottom: 14,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 170,
          child: GradientButton(
            text: "+ إضافة شكوى",
            onTap: () {
              Get.to(() => HousingComplaintCreateView());
            },
          ),
        ),
      ],
    ),
  ),
),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
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
                      top: Radius.circular(36),
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

                    if (controller.complaints.isEmpty) {
                      return _emptyState();
                    }

                    return RefreshIndicator(
                      color: AppColors.mauve,
                      onRefresh: controller.fetchComplaints,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
                        itemCount: controller.complaints.length,
                        itemBuilder: (_, i) {
                          final item = controller.complaints[i];
                          return _buildComplaintCard(item);
                        },
                      ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
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
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "شكاوى السكن",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "تابعي الشكاوى وحالة معالجتها",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: AppColors.softLavender,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 52,
              color: AppColors.darkPurple,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "لا يوجد شكاوى بعد",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "عند إضافة شكوى جديدة ستظهر هنا",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(complaint) {
    final isResolved = complaint.status == 'resolved';
    final statusColor = isResolved ? Colors.green : Colors.orange;
    final statusText = isResolved ? "تم الحل" : "قيد المعالجة";

    return  Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: statusColor.withOpacity(.20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepPurple.withOpacity(.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isResolved
                        ? Icons.check_circle_outline
                        : Icons.report_problem_outlined,
                    color: statusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.darkPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        complaint.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _smallInfoChip(
                  text: "شكوى سكن",
                  icon: Icons.home_work_outlined,
                  color: AppColors.darkPurple,
                ),
                const SizedBox(width: 8),
                _smallInfoChip(
                  text: statusText,
                  icon: Icons.circle,
                  color: statusColor,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await controller.fetchComplaintDetails(complaint.id);
                    Get.to(() => const HousingComplaintDetailView());
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text("تفاصيل"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.darkPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      
    );
  }

  Widget _smallInfoChip({
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}