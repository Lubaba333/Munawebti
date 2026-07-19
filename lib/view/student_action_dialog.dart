import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/StudentActionsController.dart';
enum StudentActionType {
  warning,
  violation,
  reward,
  report,
}
class StudentActionDialog extends StatefulWidget {
  final int studentId;
  final StudentActionType type;

  const StudentActionDialog({
    super.key,
    required this.studentId,
    required this.type,
  });

  @override
  State<StudentActionDialog> createState() =>
      _StudentActionDialogState();
}

class _StudentActionDialogState
    extends State<StudentActionDialog> {

  final actionsController =
  Get.find<StudentActionsController>();

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final extra1Controller =
  TextEditingController();

  final extra2Controller =
  TextEditingController();

  final dateController =
  TextEditingController(
    text: DateTime.now()
        .toIso8601String()
        .split('T')
        .first,
  );

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    extra1Controller.dispose();
    extra2Controller.dispose();
    dateController.dispose();
    super.dispose();
  }

  String get dialogTitle {
    switch (widget.type) {
      case StudentActionType.warning:
        return "add_warning".tr;

      case StudentActionType.violation:
        return "add_violation".tr;

      case StudentActionType.reward:
        return "add_reward".tr;

      case StudentActionType.report:
        return "add_report".tr;
    }
  }

  Future<void> submit() async {

    switch (widget.type) {

      case StudentActionType.warning:

        await actionsController.createWarning(
          studentId: widget.studentId,
          title: titleController.text,
          description: descriptionController.text,
          warningDate: dateController.text,
          possiblePenalty: extra1Controller.text,
        );

        break;

      case StudentActionType.violation:

        await actionsController.createViolation(
          studentId: widget.studentId,
          title: titleController.text,
          description: descriptionController.text,
          violationDate: dateController.text,
          category: extra1Controller.text,
          penalty: extra2Controller.text,
        );

        break;

      case StudentActionType.reward:

        await actionsController.createReward(
          studentId: widget.studentId,
          rewardType: extra1Controller.text,
          title: titleController.text,
          description: descriptionController.text,
          rewardDate: dateController.text,
          points:
          int.tryParse(extra2Controller.text) ?? 0,
        );

        break;

      case StudentActionType.report:

        await actionsController.createReport(
          studentId: widget.studentId,
          reportType: extra1Controller.text,
          description: descriptionController.text,
          reportDate: dateController.text,
          notes: extra2Controller.text,
        );

        break;
    }
  }

  List<Widget> buildFields() {

    switch (widget.type) {

      case StudentActionType.warning:

        return [
          _field(
            titleController,
            "title".tr,
          ),
          const SizedBox(height: 12),

          _field(
            descriptionController,
            "description".tr,
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          _field(
            extra1Controller,
            "possible_penalty".tr,
          ),
        ];

      case StudentActionType.violation:

        return [
          _field(
            titleController,
            "title".tr,
          ),
          const SizedBox(height: 12),

          _field(
            descriptionController,
            "description".tr,
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          _field(
            extra1Controller,
            "category".tr,
          ),
          const SizedBox(height: 12),

          _field(
            extra2Controller,
            "penalty".tr,
          ),
        ];

      case StudentActionType.reward:

        return [
          _field(
            extra1Controller,
            "reward_type".tr,
          ),
          const SizedBox(height: 12),

          _field(
            titleController,
            "title".tr,
          ),
          const SizedBox(height: 12),

          _field(
            descriptionController,
            "description".tr,
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          _field(
            extra2Controller,
            "points".tr,
            keyboardType:
            TextInputType.number,
          ),
        ];

      case StudentActionType.report:

        return [
          _field(
            extra1Controller,
            "report_type".tr,
          ),
          const SizedBox(height: 12),

          _field(
            descriptionController,
            "description".tr,
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          _field(
            extra2Controller,
            "notes".tr,
            maxLines: 3,
          ),
        ];
    }
  }

  Widget _field(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        TextInputType? keyboardType,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border:
        const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(dialogTitle),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ...buildFields(),

            const SizedBox(height: 12),

            _field(
              dateController,
              "date".tr,
            ),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: Get.back,
          child: Text("cancel".tr),
        ),

        Obx(
              () => ElevatedButton(
            onPressed: actionsController
                .loading.value
                ? null
                : submit,
            child: actionsController
                .loading.value
                ? const SizedBox(
              height: 18,
              width: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Text("save".tr),
          ),
        ),
      ],
    );
  }
}