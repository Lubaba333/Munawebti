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
  State<ComplaintDetailView> createState() =>
      _ComplaintDetailViewState();
}

class _ComplaintDetailViewState
    extends State<ComplaintDetailView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
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

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Complaint #${c.id}"),
      ),

      body: FadeTransition(
        opacity: _fade,

        child: SlideTransition(
          position: _slide,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔷 TITLE
                _animatedSection(
                  delay: 0,
                  child: _cardTitle(c.title),
                ),

                const SizedBox(height: 16),

                /// 🔷 STATUS
                _animatedSection(
                  delay: 100,
                  child: _statusBadge(c.status),
                ),

                const SizedBox(height: 20),

                /// 🔷 DESCRIPTION
                _animatedSection(
                  delay: 200,
                  child: _sectionCard(
                    title: "Description",
                    child: Text(c.description),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔷 CREATOR
                _animatedSection(
                  delay: 300,
                  child: _sectionCard(
                    title: "Creator Info",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _info("Name", c.creator.fullName),
                        _info("Email", c.creator.email),
                        _info("Specialization", c.creator.specialization),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔷 ADMIN RESPONSE
                _animatedSection(
                  delay: 400,
                  child: _sectionCard(
                    title: "Admin Response",
                    child: Text(
                      c.adminResponse ?? "No response yet",
                      style: TextStyle(
                        color: c.adminResponse == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🟣 Animated wrapper (stagger effect)
  Widget _animatedSection({
    required int delay,
    required Widget child,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  /// 🟣 Title Card
  Widget _cardTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🟣 Status badge
  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🟣 Section card
  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  /// 🟣 info row
  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}