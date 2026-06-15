
import 'package:flutter/material.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/models/request_model.dart';


class RequestDetailsView extends StatefulWidget {
  final RequestModel request;

  const RequestDetailsView({
    super.key,
    required this.request,
  });

  @override
  State<RequestDetailsView> createState() =>
      _RequestDetailsViewState();
}

class _RequestDetailsViewState
    extends State<RequestDetailsView>
    with SingleTickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    fade = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(fade);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Scaffold(
      backgroundColor: AppColors.background,
      //
      // appBar: AppBar(
      //   title: const Text("Request Details"),
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      // ),

      body: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ================= TITLE =================
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                /// STATUS BADGE (modern pill)
                _statusBadge(request.status),

                const SizedBox(height: 30),

                /// ================= DESCRIPTION =================
                _sectionHeader("Description"),
                const SizedBox(height: 8),

                Text(
                  request.description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 30),

                /// ================= INFO =================
                _sectionHeader("Request Info"),
                const SizedBox(height: 12),

                _plainRow("Type", request.type),
                const Divider(height: 25),

                _plainRow(
                  "Created",
                  request.createdAt ?? "-",
                ),

                const SizedBox(height: 30),

                /// ================= METADATA =================
                _sectionHeader("Additional Data"),
                const SizedBox(height: 12),

                ...request.metadata.entries.map((e) {
                  return Column(
                    children: [
                      _plainRow(
                        e.key,
                        e.value.toString(),
                      ),
                      const Divider(height: 25),
                    ],
                  );
                }),

                /// ================= ADMIN RESPONSE =================
                if (request.adminResponseReason != null) ...[
                  const SizedBox(height: 10),

                  _sectionHeader("Admin Response"),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      request.adminResponseReason!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _sectionHeader(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        letterSpacing: 1.2,
      ),
    );
  }

  /// ================= SIMPLE ROW =================
  Widget _plainRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= STATUS BADGE =================
  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "approved":
        color = Colors.green;
        break;
      case "rejected":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}