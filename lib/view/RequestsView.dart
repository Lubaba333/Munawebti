import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/request_controller.dart';
import 'package:supervisors/controller/supervisor_shift_controller.dart';
import 'package:supervisors/models/supervisor_shift_model.dart';
import 'package:supervisors/view/request_details_view.dart';

class RequestsView extends StatefulWidget {
  RequestsView({super.key});

  @override
  State<RequestsView> createState() =>
      _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  final controller =
  Get.find<RequestController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: Text(
          "my_requests".tr,
        ),
        backgroundColor:
        AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchRequests();
            },
          ),
        ],
      ),

      // ========================================================
      // FLOATING BUTTON
      // ========================================================

      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor:
        AppColors.primary,

        icon: const Icon(Icons.add),

        label: Text(
          "new_request".tr,
        ),

        onPressed: () {
          Get.to(
                () => CreateRequestView(),
          );
        },
      ),

      // ========================================================
      // REQUESTS
      // ========================================================

      body: Obx(() {
        // ======================================================
        // INITIAL LOADING
        // ======================================================

        if (controller.isLoading.value &&
            controller.requests.isEmpty) {
          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        // ======================================================
        // EMPTY STATE
        // ======================================================

        if (controller.requests.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              // Refresh الطلبات فقط
              await controller.fetchRequests();
            },

            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              children: [
                SizedBox(
                  height:
                  MediaQuery.of(context)
                      .size
                      .height *
                      0.7,

                  child: _emptyState(),
                ),
              ],
            ),
          );
        }

        // ======================================================
        // REQUEST LIST + PULL TO REFRESH
        // ======================================================

        return RefreshIndicator(
          onRefresh: () async {
            // ==================================================
            // فقط الطلبات
            // لا يتم تحديث المشرفين
            // ولا الـ shifts
            // ==================================================

            await controller.fetchRequests();
          },

          child: ListView.builder(
            physics:
            const AlwaysScrollableScrollPhysics(),

            padding:
            const EdgeInsets.all(16),

            itemCount:
            controller.requests.length,

            itemBuilder:
                (context, index) {
              final item =
              controller.requests[index];

              return TweenAnimationBuilder<
                  double>(
                duration: Duration(
                  milliseconds:
                  350 + (index * 100),
                ),

                tween: Tween(
                  begin: 0,
                  end: 1,
                ),

                builder: (
                    context,
                    value,
                    child,
                    ) {
                  return Opacity(
                    opacity: value,

                    child:
                    Transform.translate(
                      offset: Offset(
                        0,
                        30 *
                            (1 - value),
                      ),

                      child: child,
                    ),
                  );
                },

                child: GestureDetector(
                  // ==================================================
                  // OPEN REQUEST DETAILS
                  // ==================================================

                  onTap: () {
                    Get.to(
                          () =>
                          RequestDetailsView(
                            request: item,
                          ),

                      transition:
                      Transition
                          .rightToLeftWithFade,

                      duration:
                      const Duration(
                        milliseconds: 350,
                      ),
                    );
                  },

                  child: Container(
                    margin:
                    const EdgeInsets
                        .only(
                      bottom: 16,
                    ),

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                    BoxDecoration(
                      color: Theme.of(
                        context,
                      ).cardColor,

                      borderRadius:
                      BorderRadius
                          .circular(
                        22,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                            .08,
                          ),

                          blurRadius: 12,

                          offset:
                          const Offset(
                            0,
                            5,
                          ),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [
                        // ==========================================
                        // HEADER
                        // ==========================================

                        Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,

                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .primary
                                    .withOpacity(
                                  .12,
                                ),

                                shape: BoxShape
                                    .circle,
                              ),

                              child: Icon(
                                item.type ==
                                    "supervisor_leave"
                                    ? Icons
                                    .event_busy
                                    : Icons
                                    .swap_horiz,

                                color: AppColors
                                    .primary,
                              ),
                            ),

                            const SizedBox(
                              width: 14,
                            ),

                            Expanded(
                              child: Text(
                                item.title,

                                maxLines: 1,

                                overflow:
                                TextOverflow
                                    .ellipsis,

                                style:
                                const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),

                            _statusChip(
                              item.status,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // ==========================================
                        // DESCRIPTION
                        // ==========================================

                        Text(
                          item.description,

                          maxLines: 2,

                          overflow:
                          TextOverflow
                              .ellipsis,

                          style: TextStyle(
                            fontSize: 14,

                            color: Theme.of(
                              context,
                            )
                                .textTheme
                                .bodyMedium
                                ?.color,

                            height: 1.4,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ==========================================
                        // TYPE
                        // ==========================================

                        Row(
                          children: [
                            Container(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),

                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .primary
                                    .withOpacity(
                                  .10,
                                ),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  20,
                                ),
                              ),

                              child: Text(
                                _typeLabel(
                                  item.type,
                                ),

                                style:
                                TextStyle(
                                  color: AppColors
                                      .primary,

                                  fontSize: 12,

                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),

                            const Spacer(),

                            Icon(
                              Icons
                                  .arrow_forward_ios,

                              size: 16,

                              color: Theme.of(
                                context,
                              )
                                  .textTheme
                                  .bodySmall
                                  ?.color,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ==========================================
                        // CANCEL REQUEST
                        // ==========================================

                        if (item.status ==
                            "pending")
                          Align(
                            alignment:
                            Alignment
                                .centerRight,

                            child:
                            TextButton
                                .icon(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title:
                                    Text(
                                      "cancel_request"
                                          .tr,
                                    ),

                                    content:
                                    Text(
                                      "cancel_request_confirm"
                                          .tr,
                                    ),

                                    actions: [
                                      // NO
                                      TextButton(
                                        onPressed:
                                            () {
                                          Get.back();
                                        },

                                        child:
                                        Text(
                                          "no"
                                              .tr,
                                        ),
                                      ),

                                      // YES
                                      ElevatedButton(
                                        onPressed:
                                            () {
                                          Get.back();

                                          controller
                                              .cancelRequest(
                                            item.id,
                                          );
                                        },

                                        child:
                                        Text(
                                          "yes"
                                              .tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },

                              icon:
                              const Icon(
                                Icons.cancel,
                                color:
                                Colors.red,
                              ),

                              label: Text(
                                "cancel_request"
                                    .tr,

                                style:
                                const TextStyle(
                                  color:
                                  Colors.red,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            "no_requests_yet".tr,

            style:
            const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            "create_first_request".tr,

            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          ElevatedButton(
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.primary,

              foregroundColor:
              Colors.white,
            ),

            onPressed: () {
              Get.to(
                    () =>
                    CreateRequestView(),
              );
            },

            child: Text(
              "create_request".tr,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUEST TYPE LABEL
  // ============================================================

  String _typeLabel(String type) {
    switch (type) {
      case "supervisor_leave":
        return "leave_request".tr;

      case "supervisor_shift_exchange":
        return "shift_exchange".tr;

      default:
        return type.replaceAll(
          "_",
          " ",
        );
    }
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================

  Widget _statusChip(
      String status,
      ) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = "pending".tr;
        break;

      case 'approved':
        color = Colors.green;
        label = "approved".tr;
        break;

      case 'rejected':
        color = Colors.red;
        label = "rejected".tr;
        break;

      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration:
      BoxDecoration(
        color: color.withOpacity(
          0.15,
        ),

        borderRadius:
        BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: color,
        ),
      ),

      child: Text(
        label,

        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }
}

// =================================================================
// CREATE REQUEST VIEW
// =================================================================

class CreateRequestView extends StatefulWidget {
  const CreateRequestView({super.key});

  @override
  State<CreateRequestView> createState() =>
      _CreateRequestViewState();
}

class _CreateRequestViewState
    extends State<CreateRequestView> {

  // ======================================================
  // CONTROLLERS
  // ======================================================

  final shiftsController =
  Get.find<SupervisorShiftsController>();

  final requestController =
  Get.find<RequestController>();

  // ======================================================
  // REQUEST TYPE
  // ======================================================

  String selectedType = "supervisor_leave";

  // ======================================================
  // LEAVE
  // ======================================================

  final leaveDate = TextEditingController();

  final reason = TextEditingController();

  final description = TextEditingController();

  // ======================================================
  // SHIFT EXCHANGE
  // ======================================================

  int? selectedSupervisorId;

  SupervisorShift? selectedShift;

  ShiftType? selectedShiftType;

  final shiftDate = TextEditingController();

  final fromHour = TextEditingController();

  final toHour = TextEditingController();

  final shiftDescription = TextEditingController();

  // ======================================================
  // DISPOSE
  // ======================================================

  @override
  void dispose() {
    leaveDate.dispose();
    reason.dispose();
    description.dispose();

    shiftDate.dispose();
    fromHour.dispose();
    toHour.dispose();
    shiftDescription.dispose();

    super.dispose();
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create_request".tr),
        backgroundColor: AppColors.primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ==================================================
            // REQUEST TYPE
            // ==================================================

            DropdownButtonFormField<String>(
              value: selectedType,

              isExpanded: true,

              decoration: InputDecoration(
                labelText: "request_type".tr,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              items: [

                DropdownMenuItem(
                  value: "supervisor_leave",

                  child: Text(
                    "leave_request".tr,
                  ),
                ),

                DropdownMenuItem(
                  value:
                  "supervisor_shift_exchange",

                  child: Text(
                    "shift_exchange".tr,
                  ),
                ),
              ],

              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedType = value;

                  // تنظيف بيانات الشفت
                  selectedShift = null;
                  selectedShiftType = null;

                  shiftDate.clear();
                  fromHour.clear();
                  toHour.clear();
                });
              },
            ),

            const SizedBox(height: 16),

            // ==================================================
            // FORM
            // ==================================================

            if (selectedType ==
                "supervisor_leave")

              _leaveForm()

            else

              _shiftForm(),

            const SizedBox(height: 20),

            // ==================================================
            // SUBMIT
            // ==================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,

                  foregroundColor:
                  Colors.white,

                  padding:
                  const EdgeInsets.all(15),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                onPressed: _submit,

                child: Text(
                  "submit_request".tr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // LEAVE FORM
  // ======================================================

  Widget _leaveForm() {
    return Column(
      children: [

        // DESCRIPTION
        TextField(
          controller: description,

          maxLines: 3,

          decoration: InputDecoration(
            labelText: "description".tr,

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // DATE
        TextField(
          controller: leaveDate,

          readOnly: true,

          decoration: InputDecoration(
            labelText: "leave_date".tr,

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(12),
            ),

            suffixIcon:
            const Icon(
              Icons.calendar_today,
            ),
          ),

          onTap: () async {
            final pickedDate =
            await showDatePicker(
              context: context,

              initialDate:
              DateTime.now(),

              firstDate:
              DateTime(2020),

              lastDate:
              DateTime(2035),
            );

            if (pickedDate != null) {
              leaveDate.text =
              "${pickedDate.year}-"
                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                  "${pickedDate.day.toString().padLeft(2, '0')}";
            }
          },
        ),

        const SizedBox(height: 12),

        // REASON
        TextField(
          controller: reason,

          decoration: InputDecoration(
            labelText: "reason".tr,

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================
  // SHIFT FORM
  // ======================================================

  Widget _shiftForm() {
    return Column(
      children: [

        // ==================================================
        // SUPERVISOR
        // ==================================================

        GetX<RequestController>(
          builder: (controller) {

            if (controller
                .isLoadingSupervisors.value) {
              return const Padding(
                padding:
                EdgeInsets.all(10),

                child:
                CircularProgressIndicator(),
              );
            }

            final supervisors =
            controller.supervisors;

            return DropdownButtonFormField<int>(
              value: selectedSupervisorId,

              isExpanded: true,

              decoration:
              InputDecoration(
                labelText:
                "select_supervisor".tr,

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
              ),

              items:
              supervisors.map((sup) {

                return DropdownMenuItem<int>(
                  value: sup.id,

                  child: Text(
                    "${sup.fullName} "
                        "(${sup.specialization})",

                    overflow:
                    TextOverflow.ellipsis,
                  ),
                );
              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedSupervisorId =
                      value;
                });
              },
            );
          },
        ),

        const SizedBox(height: 12),

        // ==================================================
        // DESCRIPTION
        // ==================================================

        TextField(
          controller:
          shiftDescription,

          maxLines: 3,

          decoration:
          InputDecoration(
            labelText:
            "description".tr,

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==================================================
        // SHIFT TYPE
        // ==================================================

        DropdownButtonFormField<ShiftType>(
          value: selectedShiftType,

          isExpanded: true,

          decoration:
          InputDecoration(
            labelText:
            "shift_type".tr,

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),

          items: [

            DropdownMenuItem<ShiftType>(
              value:
              ShiftType.lecture,

              child: Text(
                "lecture".tr,
              ),
            ),

            DropdownMenuItem<ShiftType>(
              value:
              ShiftType.housing,

              child: Text(
                "housing".tr,
              ),
            ),
          ],

          onChanged: (value) async {

            if (value == null) {
              return;
            }

            // أولاً نحدث الواجهة
            setState(() {
              selectedShiftType =
                  value;

              selectedShift = null;

              shiftDate.clear();
              fromHour.clear();
              toHour.clear();
            });

            // تحميل الشفتات الخاصة بالنوع
            await shiftsController
                .changeType(value);
          },
        ),

        const SizedBox(height: 12),

        // ==================================================
        // SELECT SHIFT
        // ==================================================
        //
        // ملاحظة مهمة:
        // نستخدم "day.date" كتاريخ صحيح لليوم بدل
        // "shift.shiftDate" لأن الأخير مخزن بصيغة UTC
        // وبيسبب فرق يوم كامل عن التاريخ الفعلي
        // (نفس المنطق المستخدم بالكاليندر buildShiftsMap)
        // ==================================================

        GetBuilder<SupervisorShiftsController>(
          builder: (shiftController) {

            // ----------------------------------------------
            // LOADING
            // ----------------------------------------------

            if (shiftController
                .isLoading.value) {

              return InputDecorator(
                decoration:
                InputDecoration(
                  labelText:
                  "select_shift".tr,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                child: const Row(
                  children: [

                    SizedBox(
                      width: 20,
                      height: 20,

                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),

                    SizedBox(width: 12),

                    Text(
                      "Loading shifts...",
                    ),
                  ],
                ),
              );
            }

            // ----------------------------------------------
            // GET ALL SHIFTS (بنفس منطق الكاليندر بالضبط)
            // ----------------------------------------------

            final now =
            DateTime.now();

            final List<SupervisorShift>
            availableShifts = [];

            // خريطة: shift.id → التاريخ الصحيح لليوم
            // (نفس day.date المستخدم بالكاليندر)
            final Map<int, String>
            shiftDates = {};

            for (final day
            in shiftController.shifts) {

              final dayDate =
                  day.date; // التاريخ الصحيح مثل "2026-08-25"

              for (final shift
              in day.shifts) {

                try {

                  final end =
                  shift.endTime
                      .substring(
                    0,
                    5,
                  );

                  final endDateTime =
                  DateTime.parse(
                    "$dayDate $end:00",
                  );

                  if (endDateTime
                      .isAfter(now)) {

                    availableShifts
                        .add(shift);

                    shiftDates[shift.id] =
                        dayDate;
                  }

                } catch (_) {
                  // تجاهل الشفت الذي فيه تاريخ غير صالح
                }
              }
            }

            // ----------------------------------------------
            // NO SHIFTS
            // ----------------------------------------------

            if (availableShifts.isEmpty) {

              return InputDecorator(
                decoration:
                InputDecoration(
                  labelText:
                  "select_shift".tr,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                child: Text(
                  "no_available_shifts".tr,
                ),
              );
            }

            // ----------------------------------------------
            // DROPDOWN
            // ----------------------------------------------

            return DropdownButtonFormField<
                SupervisorShift>(
              value: selectedShift,

              isExpanded: true,

              decoration:
              InputDecoration(
                labelText:
                "select_shift".tr,

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
              ),

              items:
              availableShifts.map(
                    (shift) {

                  // التاريخ الصحيح من الخريطة
                  final correctDate =
                  shiftDates[shift.id]!;

                  return DropdownMenuItem<
                      SupervisorShift>(
                    value: shift,

                    child: Text(
                      "$correctDate "
                          "${shift.startTime.substring(0, 5)} - "
                          "${shift.endTime.substring(0, 5)}",

                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),

              onChanged: (value) {

                if (value == null) {
                  return;
                }

                setState(() {

                  selectedShift =
                      value;

                  // نستخدم التاريخ الصحيح
                  // من الخريطة بدل value.shiftDate
                  shiftDate.text =
                  shiftDates[value.id]!;

                  fromHour.text =
                      value.startTime
                          .substring(
                        0,
                        5,
                      );

                  toHour.text =
                      value.endTime
                          .substring(
                        0,
                        5,
                      );
                });
              },
            );
          },
        ),

        const SizedBox(height: 12),

        // ==================================================
        // SHIFT DATE
        // ==================================================

        TextField(
          controller: shiftDate,

          readOnly: true,

          decoration:
          InputDecoration(
            labelText:
            "shift_date".tr,

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==================================================
        // FROM
        // ==================================================

        TextField(
          controller: fromHour,

          readOnly: true,

          decoration:
          InputDecoration(
            labelText:
            "from_hour".tr,

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==================================================
        // TO
        // ==================================================

        TextField(
          controller: toHour,

          readOnly: true,

          decoration:
          InputDecoration(
            labelText:
            "to_hour".tr,

            border:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================
  // SUBMIT
  // ======================================================

  Future<void> _submit() async {

    // ====================================================
    // LEAVE
    // ====================================================

    if (selectedType ==
        "supervisor_leave") {

      if (leaveDate.text.isEmpty) {

        Get.snackbar(
          "error".tr,
          "please_select_date".tr,
        );

        return;
      }

      if (reason.text.trim().isEmpty) {

        Get.snackbar(
          "error".tr,
          "please_enter_reason".tr,
        );

        return;
      }

      if (description.text.trim().isEmpty) {

        Get.snackbar(
          "error".tr,
          "please_enter_description".tr,
        );

        return;
      }

      await requestController
          .createLeaveRequest(

        date: leaveDate.text,

        reason:
        reason.text.trim(),

        description:
        description.text.trim(),
      );

      Get.back();

      return;
    }

    // ====================================================
    // SHIFT EXCHANGE
    // ====================================================

    if (selectedSupervisorId == null) {

      Get.snackbar(
        "error".tr,
        "please_select_supervisor".tr,
      );

      return;
    }

    if (selectedShiftType == null) {

      Get.snackbar(
        "error".tr,
        "please_select_shift_type".tr,
      );

      return;
    }

    if (selectedShift == null) {

      Get.snackbar(
        "error".tr,
        "please_select_shift".tr,
      );

      return;
    }

    if (shiftDescription.text
        .trim()
        .isEmpty) {

      Get.snackbar(
        "error".tr,
        "please_enter_description".tr,
      );

      return;
    }

    // ====================================================
    // CREATE REQUEST
    // ====================================================

    await requestController
        .createShiftExchange(

      targetSupervisorId:
      selectedSupervisorId!,

      shiftId:
      selectedShift!.id,

      date:
      shiftDate.text,

      fromHour:
      fromHour.text,

      toHour:
      toHour.text,

      description:
      shiftDescription.text.trim(),
    );

    Get.back();
  }
}
