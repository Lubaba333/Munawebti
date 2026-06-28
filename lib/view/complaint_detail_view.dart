import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/models/housing_complaint_model.dart';

class ComplaintDetailView extends StatefulWidget {
  final HousingComplaint complaint;

  const ComplaintDetailView({
    super.key,
    required this.complaint,
  });

  @override
  State<ComplaintDetailView> createState() => _ComplaintDetailViewState();
}

class _ComplaintDetailViewState extends State<ComplaintDetailView> {
  Color statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.complaint;
    final color = statusColor(c.status);

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),

      body: CustomScrollView(
        slivers: [

          // ================= APP BAR =================
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  // gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(.7),
                        ],
                      ),
                    ),
                  ),

                  // blur overlay
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(color: Colors.transparent),
                  ),

                  // content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 700),
                          tween: Tween<double>(begin: 0, end: 1),
                          curve: Curves.easeOutBack,
                          builder: (context, v, _) {
                            return Transform.scale(
                              scale: v,
                              child: Icon(
                                Icons.report_problem,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            c.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            c.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= BODY =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _sectionTitle("الوصف"),
                  _animatedBlock(_textBlock(Icons.description, c.description)),

                  const SizedBox(height: 25),

                  _sectionTitle("معلومات المنشئ"),
                  _animatedBlock(_creator(c)),

                  const SizedBox(height: 25),

                  _sectionTitle("رد الإدارة"),
                  _animatedBlock(
                    _textBlock(
                      Icons.message,
                      c.adminResponse ?? "لا يوجد رد حالياً",
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TEXT BLOCK (NO CARDS) =================

  Widget _textBlock(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  // ================= CREATOR BLOCK =================

  Widget _creator(HousingComplaint c) {
    return Column(
      children: [
        _line(Icons.person, "الاسم", c.creator.fullName),
        _line(Icons.email, "الايميل", c.creator.email),
        _line(Icons.school, "الاختصاص", c.creator.specialization),
      ],
    );
  }

  Widget _line(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ANIMATION =================

  Widget _animatedBlock(Widget child) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - v)),
            child: child,
          ),
        );
      },
    );
  }
}