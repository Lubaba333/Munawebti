import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/request_controller.dart';
import 'package:supervisors/view/request_details_view.dart';

class RequestsView extends StatefulWidget {

  RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  final controller = Get.find<RequestController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("My Requests"),
        backgroundColor: AppColors.primary,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add),
        label: Text("New Request"),
        onPressed: () {
          Get.to(() => CreateRequestView());
        },
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return _emptyState();
        }

        return ListView.builder(

          padding: const EdgeInsets.all(16),

          itemCount: controller.requests.length,


          itemBuilder: (context, index) {

            final item = controller.requests[index];


            return TweenAnimationBuilder<double>(

              duration: Duration(
                milliseconds: 350 + (index * 100),
              ),


              tween: Tween(
                begin: 0,
                end: 1,
              ),


              builder: (context,value,child){


                return Opacity(

                  opacity: value,


                  child: Transform.translate(

                    offset: Offset(
                      0,
                      30 * (1-value),
                    ),


                    child: child,

                  ),

                );


              },


              child: GestureDetector(


                onTap: (){


                  Get.to(

                        ()=> RequestDetailsView(
                      request: item,
                    ),


                    transition:
                    Transition.rightToLeftWithFade,


                    duration:
                    const Duration(milliseconds:350),

                  );


                },



                child: Container(

                  margin: const EdgeInsets.only(
                      bottom:16
                  ),


                  padding: const EdgeInsets.all(18),



                  decoration: BoxDecoration(

                    color: Colors.white,


                    borderRadius:
                    BorderRadius.circular(22),



                    boxShadow: [

                      BoxShadow(

                        color:
                        Colors.black.withOpacity(.08),


                        blurRadius:12,


                        offset:
                        const Offset(0,5),

                      )

                    ],


                  ),



                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children: [



                      Row(

                        children: [


                          Container(

                            height:45,

                            width:45,


                            decoration: BoxDecoration(

                              color:
                              AppColors.primary
                                  .withOpacity(.12),


                              shape:
                              BoxShape.circle,

                            ),



                            child: Icon(

                              item.type ==
                                  "supervisor_leave"

                                  ?

                              Icons.event_busy

                                  :

                              Icons.swap_horiz,


                              color:
                              AppColors.primary,

                            ),

                          ),



                          const SizedBox(width:14),




                          Expanded(

                            child:

                            Text(

                              item.title,


                              maxLines:1,


                              overflow:
                              TextOverflow.ellipsis,


                              style:

                              const TextStyle(

                                fontSize:17,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                          ),



                          _statusChip(
                              item.status
                          )


                        ],

                      ),




                      const SizedBox(height:15),




                      Text(

                        item.description,


                        maxLines:2,


                        overflow:
                        TextOverflow.ellipsis,


                        style:

                        TextStyle(

                          fontSize:14,


                          color:
                          Colors.grey.shade700,

                          height:1.4,

                        ),


                      ),




                      const SizedBox(height:18),





                      Row(

                        children: [



                          Container(

                            padding:
                            const EdgeInsets.symmetric(

                              horizontal:12,

                              vertical:7,

                            ),



                            decoration:

                            BoxDecoration(

                              color:

                              AppColors.primary
                                  .withOpacity(.10),


                              borderRadius:
                              BorderRadius.circular(20),

                            ),



                            child:

                            Text(

                              item.type
                                  .replaceAll(
                                  "_",
                                  " "
                              ),



                              style:

                              TextStyle(

                                color:
                                AppColors.primary,


                                fontSize:12,


                                fontWeight:
                                FontWeight.w600,

                              ),

                            ),


                          ),




                          const Spacer(),




                          Icon(

                            Icons.arrow_forward_ios,

                            size:16,


                            color:
                            Colors.grey.shade400,

                          )

                        ],

                      ),

                      const SizedBox(height: 10),

                      if (item.status == "pending")
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text("Cancel Request"),
                                  content: Text("Are you sure you want to cancel this request?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text("No"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.cancelRequest(item.id);
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.cancel, color: Colors.red),
                            label: Text(
                              "Cancel Request",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),

                    ],


                  ),



                ),


              ),

            );

          },

        );
      }),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No Requests Yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("Create your first request",
              style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              Get.to(() => CreateRequestView());
            },
            child: Text("Create Request"),
          )
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = "Pending";
        break;

      case 'approved':
        color = Colors.green;
        label = "Approved";
        break;

      case 'rejected':
        color = Colors.red;
        label = "Rejected";

        break;

      default:
        color = Colors.grey;
        label = status;
    }

    return Container(

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),

    );
  }
}


class CreateRequestView extends StatefulWidget {

  CreateRequestView({super.key});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  final controller = Get.find<RequestController>();

  final RxString selectedType = "supervisor_leave".obs;

  final leaveDate = TextEditingController();

  final reason = TextEditingController();

  final description = TextEditingController();

  int? selectedSupervisorId;
  int? selectedShiftId;

  final shiftDate = TextEditingController();

  final fromHour = TextEditingController();

  final toHour = TextEditingController();

  final shiftDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Create Request"),
        backgroundColor: AppColors.primary,
      ),

        body: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [


            /// TYPE SELECT
            Obx(() => DropdownButtonFormField(
              value: selectedType.value,
              items: [
                DropdownMenuItem(
                  value: "supervisor_leave",
                  child: Text("Leave Request"),
                ),
                DropdownMenuItem(
                  value: "supervisor_shift_exchange",
                  child: Text("Shift Exchange"),
                ),
              ],
              onChanged: (value) {
                selectedType.value = value!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            )),

            SizedBox(height: 15),

            /// DYNAMIC FORM
            Obx(() {
              return selectedType.value == "supervisor_leave"
                  ? _leaveForm()
                  : _shiftForm();
            }),

            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.all(14),
                ),
                onPressed: () async {
                  await _submit();
                },
                child: Text("Submit Request"),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  /// ================= LEAVE =================
  Widget _leaveForm() {
    return Column(
      children: [
        TextField(
          controller: description,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: "Description",
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: leaveDate,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Leave Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );

            if (pickedDate != null) {
              leaveDate.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            }
          },
        ),

        SizedBox(height: 10),

        TextField(
          controller: reason,
          decoration: InputDecoration(
            labelText: "Reason",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
  /// ================= SHIFT =================
  Widget _shiftForm() {
    return Column(
      children: [

        Obx(() {
          if (controller.isLoadingSupervisors.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return DropdownButtonFormField<int>(
            isExpanded: true,
            value: selectedSupervisorId,

            decoration: InputDecoration(
              labelText: "Select Supervisor",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            items: controller.supervisors
                .where((sup) => sup.id != controller.currentUserId)
                .map((sup) {
              return DropdownMenuItem<int>(
                value: sup.id,
                child: Text("${sup.fullName} (${sup.specialization})"),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selectedSupervisorId = value;
              });
            },
          );
        }),

        SizedBox(height: 10),

        TextField(
          controller: shiftDescription,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: "Description",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),


        SizedBox(height: 10),

        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Original Shift ID",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            selectedShiftId = int.tryParse(value);
          },
        ),

        SizedBox(height: 10),
        TextField(
          controller: shiftDate,
          readOnly: true, // يمنع الكتابة اليدوية
          decoration: InputDecoration(
            labelText: "Shift Date",
            hintText: "Select Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );

            if (pickedDate != null) {
              shiftDate.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            }
          },
        ),
        SizedBox(height: 10),


        TextField(
          readOnly: true,
          controller: fromHour,
          decoration: InputDecoration(
            labelText: "From Hour",
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time != null) {
              fromHour.text =
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
            }
          },
        ),

        SizedBox(height: 10),


        TextField(
          readOnly: true,
          controller: toHour,
          decoration: InputDecoration(
            labelText: "To Hour",
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time != null) {
              toHour.text =
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
            }
          },
        ),


      ],
    );
  }

  /// ================= SUBMIT =================
  Future<void> _submit() async {
    if (selectedType.value == "supervisor_leave") {
      await controller.createLeaveRequest(
        date: leaveDate.text,
        reason: reason.text,
        description:description.text,
      );
    } else {
      await controller.createShiftExchange(
        targetSupervisorId: selectedSupervisorId!,
        shiftId: selectedShiftId!,
        date: shiftDate.text,
        fromHour: fromHour.text,
        toHour: toHour.text,
        description: shiftDescription.text,
      );
    }

    Get.back();
  }
}
