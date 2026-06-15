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
    controller.fetchRequests(); // 🔥 كل مرة تفتح الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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

        // return ListView.builder(
        //   padding: EdgeInsets.all(12),
        //   itemCount: controller.requests.length,
        //   itemBuilder: (context, index) {
        //     final item = controller.requests[index];
        //
        //     return TweenAnimationBuilder<double>(
        //
        //         duration: Duration(
        //           milliseconds: 400 + (index * 100),
        //         ),
        //
        //
        //         tween: Tween(
        //           begin: 0,
        //           end: 1,
        //         ),
        //
        //
        //         builder: (context,value,child){
        //
        //
        //           return Transform.translate(
        //
        //             offset: Offset(
        //               0,
        //               40 * (1-value),
        //             ),
        //
        //
        //             child: Opacity(
        //
        //               opacity:value,
        //
        //
        //               child: child,
        //
        //             ),
        //
        //           );
        //
        //
        //         },
        //
        //
        //
        //         child: InkWell(
        //
        //
        //             borderRadius: BorderRadius.circular(16),
        //
        //
        //             onTap: (){
        //
        //
        //               Get.to(
        //
        //                     ()=>RequestDetailsView(
        //                   request:item,
        //                 ),
        //
        //
        //                 transition:
        //                 Transition.rightToLeftWithFade,
        //
        //
        //                 duration:
        //                 Duration(milliseconds:350),
        //
        //
        //               );
        //
        //
        //             },
        //
        //
        //             child: AnimatedScale(
        //
        //                 scale: 1,
        //
        //                 duration:
        //                 Duration(milliseconds:150),
        //
        //
        //                 child: Container(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Expanded(
        //                 child: Text(
        //                   item.title,
        //                   style: TextStyle(
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                 ),
        //               ),
        //               _statusChip(item.status),
        //             ],
        //           ),
        //
        //           SizedBox(height: 8),
        //
        //           Text(
        //             item.description,
        //             style: TextStyle(color: Colors.grey[700]),
        //           ),
        //
        //           SizedBox(height: 10),
        //
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //             decoration: BoxDecoration(
        //               color: AppColors.primary.withOpacity(0.1),
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //             child: Text(
        //               item.type,
        //               style: TextStyle(
        //                 color: AppColors.primary,
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ))));
        //   },
        // );


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

                      )


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

    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
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

  final targetSupervisorId = TextEditingController();

  final shiftId = TextEditingController();

  final shiftDate = TextEditingController();

  final fromHour = TextEditingController();

  final toHour = TextEditingController();

  final shiftDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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
          decoration: InputDecoration(
            labelText: "Leave Date",
            border: OutlineInputBorder(),
          ),
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
            value: targetSupervisorId.text.isEmpty
                ? null
                : int.tryParse(targetSupervisorId.text),

            decoration: InputDecoration(
              labelText: "Select Supervisor",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            items: controller.supervisors.map((sup) {

              return DropdownMenuItem<int>(

                value: sup.id,


                child: SizedBox(

                  width: MediaQuery.of(context).size.width * 0.65,


                  child: Text(

                    "${sup.fullName} (${sup.specialization})",


                    overflow: TextOverflow.ellipsis,


                    maxLines: 1,


                    style: const TextStyle(
                      fontSize: 14,
                    ),

                  ),

                ),

              );


            }).toList(),

            onChanged: (value) {
              if (value != null) {
                targetSupervisorId.text = value.toString();
              }
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
          controller: shiftId,
          decoration: InputDecoration(
            labelText: "Original Shift ID",
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: shiftDate,
          decoration: InputDecoration(
            labelText: "Shift Date",
            hintText: "08:00",
            border: OutlineInputBorder(),
          ),
        ),
        //
        // TextField(
        //   controller: fromHour,
        //   readOnly: true,
        //   onTap: () async {
        //     final time = await showTimePicker(
        //       context: context,
        //       initialTime: TimeOfDay.now(),
        //     );
        //
        //     if (time != null) {
        //       fromHour.text =
        //       "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
        //     }
        //   },
        // ),

        SizedBox(height: 10),

        TextField(
          controller: fromHour,
          decoration: InputDecoration(
            labelText: "From Hour",
            hintText: "12:00",
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: toHour,
          decoration: InputDecoration(
            labelText: "To Hour",
            hintText: "02:30",
            border: OutlineInputBorder(),
          ),
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
        targetSupervisorId: int.parse(targetSupervisorId.text),
        shiftId: int.parse(shiftId.text),
        date: shiftDate.text,
        fromHour: fromHour.text,
        toHour: toHour.text,
        description:description.text,

      );
    }

    Get.back();
  }
}

