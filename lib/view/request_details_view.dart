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
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView>
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
      begin: const Offset(0, .05),
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text("Request Details"),
      ),
      body: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                _statusBadge(request.status),

                const SizedBox(height: 30),

                Divider(color: Colors.grey.shade300),

                const SizedBox(height: 20),

                /// DESCRIPTION
                _sectionHeader("Description"),

                Text(
                  request.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 20),

                Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 20),

                  _sectionHeader("Additional Information"),

                  ...request.metadata.entries.map(
                        (entry) => _infoRow(
                      Icons.info_outline,
                      entry.key,
                      entry.value.toString(),
                    ),
                  ),

                if (request.adminResponseReason != null &&
                    request.adminResponseReason!.isNotEmpty) ...[
                  const SizedBox(height: 30),

                  Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 25),

                  _sectionHeader("Admin Response"),

                  Text(
                    request.adminResponseReason!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
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

  Widget _infoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.primary,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case "approved":
        color = Colors.green;
        icon = Icons.check_circle;
        break;

      case "rejected":
        color = Colors.red;
        icon = Icons.cancel;
        break;

      default:
        color = Colors.orange;
        icon = Icons.access_time_filled;
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          status.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}