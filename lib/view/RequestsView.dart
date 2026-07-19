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
        title: Text("my_requests".tr),
        backgroundColor: AppColors.primary,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add),
        label: Text("new_request".tr),
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

                    color: Theme.of(context).cardColor,


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
                          Theme.of(context).textTheme.bodyMedium?.color,

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

                              _typeLabel(item.type),



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
                            Theme.of(context).textTheme.bodySmall?.color,

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
                                  title: Text("cancel_request".tr),
                                  content: Text("cancel_request_confirm".tr),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text("no".tr),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.cancelRequest(item.id);
                                      },
                                      child: Text("yes".tr),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.cancel, color: Colors.red),
                            label: Text(
                              "cancel_request".tr,
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
            "no_requests_yet".tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("create_first_request".tr,
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.to(() => CreateRequestView());
            },
            child: Text("create_request".tr),
          )
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case "supervisor_leave":
        return "leave_request".tr;
      case "supervisor_shift_exchange":
        return "shift_exchange".tr;
      default:
        return type.replaceAll("_", " ");
    }
  }

  Widget _statusChip(String status) {
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

  final shiftsController = Get.find<SupervisorShiftsController>();

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

  ShiftType? selectedShiftType;

  SupervisorShift? selectedShift;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("create_request".tr),
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
                  child: Text("leave_request".tr),
                ),
                DropdownMenuItem(
                  value: "supervisor_shift_exchange",
                  child: Text("shift_exchange".tr),
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
            // Obx(() {
            //   return selectedType.value == "supervisor_leave"
            //       ? _leaveForm()
            //       : _shiftForm();
            // }),

                Obx(() {

                  if(selectedType.value == "supervisor_leave"){

                    return _leaveForm();

                  }else{

                    return _shiftForm();

                  }

                }),

            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(14),
                ),
                onPressed: () async {
                  await _submit();
                },
                child: Text("submit_request".tr),
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
            labelText: "description".tr,
            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: leaveDate,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "leave_date".tr,
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
            labelText: "reason".tr,
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
              labelText: "select_supervisor".tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            items: controller.supervisors
                .where((sup) => sup.id != controller.currentUserId)
                .map((sup) {
            // items: controller.supervisors.map((sup) {
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
            labelText: "description".tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),


        SizedBox(height: 10),

/////////////////////////////////////////
        DropdownButtonFormField<ShiftType>(

          value: selectedShiftType,


          decoration: InputDecoration(

            labelText: "shift_type".tr,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

          ),



          items:  [


            DropdownMenuItem(

              value: ShiftType.lecture,

              child: Text("lecture".tr),

            ),



            DropdownMenuItem(

              value: ShiftType.housing,

              child: Text("housing".tr),

            ),


          ],



          onChanged: (value){

            setState((){

              selectedShiftType = value;

              selectedShift = null;


              shiftDate.clear();

              fromHour.clear();

              toHour.clear();

            });


            shiftsController.changeType(value!);

          },

        ),
        //////////////////////////////////////////
        SizedBox(height: 10),

    Obx((){


    final shifts =
    shiftsController.shifts
        .expand((day)=>day.shifts)
        .toList();



    return DropdownButtonFormField<SupervisorShift>(


    value:selectedShift,


    decoration: InputDecoration(

    labelText:"select_shift".tr,

    border:OutlineInputBorder(

    borderRadius:BorderRadius.circular(12),

    ),

    ),



    items: shifts.map((shift){


    return DropdownMenuItem<SupervisorShift>(


    value:shift,


    child:Text(

    "${shift.shiftDate.substring(0,10)} "
    "${shift.startTime} - ${shift.endTime}",

    ),


    );


    }).toList(),



      onChanged:(value){

        if(value == null) return;


        setState((){

          selectedShift = value;


          shiftDate.text =
              value.shiftDate.substring(0,10);


          fromHour.text =
              value.startTime.substring(0,5);


          toHour.text =
              value.endTime.substring(0,5);


        });

      },



    );


    }),
   ////////////////////////////////////////////////

        SizedBox(height: 10),
        TextField(
          controller: shiftDate,

          readOnly: true,

          decoration: InputDecoration(
            labelText: "shift_date".tr,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: fromHour,

          readOnly: true,

          decoration: InputDecoration(
            labelText: "from_hour".tr,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

          ),
        ),

        SizedBox(height: 10),

        TextField(
          controller: toHour,

          readOnly: true,

          decoration: InputDecoration(
            labelText: "to_hour".tr,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),

          ),
        ),


      ],
    );
  }

  /// ================= SUBMIT =================
  Future<void> _submit() async {


    if(selectedType.value == "supervisor_leave"){


      await controller.createLeaveRequest(

        date: leaveDate.text,

        reason: reason.text,

        description: description.text,

      );


    }else{


      if(selectedSupervisorId == null){

        Get.snackbar(
          "error".tr,
          "please_select_supervisor".tr,
        );

        return;

      }


      if(selectedShift == null){

        Get.snackbar(
          "error".tr,
          "please_select_shift".tr,
        );

        return;

      }



      await controller.createShiftExchange(

        targetSupervisorId: selectedSupervisorId!,


        shiftId: selectedShift!.id,


        date: shiftDate.text,


        fromHour: fromHour.text,


        toHour: toHour.text,


        description: shiftDescription.text,

      );

    }


    Get.back();

  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supervisors/const/app_colors.dart';
// import 'package:supervisors/controller/request_controller.dart';
// import 'package:supervisors/controller/supervisor_shift_controller.dart';
// import 'package:supervisors/models/supervisor_shift_model.dart';
// import 'package:supervisors/view/request_details_view.dart';
//
// class RequestsView extends StatefulWidget {
//
//   RequestsView({super.key});
//
//   @override
//   State<RequestsView> createState() => _RequestsViewState();
// }
//
// class _RequestsViewState extends State<RequestsView> {
//   final controller = Get.find<RequestController>();
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text("My Requests"),
//         backgroundColor: AppColors.primary,
//       ),
//
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColors.primary,
//         icon: Icon(Icons.add),
//         label: Text("New Request"),
//         onPressed: () {
//           Get.to(() => CreateRequestView());
//         },
//       ),
//
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.requests.isEmpty) {
//           return _emptyState();
//         }
//
//         return ListView.builder(
//
//           padding: const EdgeInsets.all(16),
//
//           itemCount: controller.requests.length,
//
//
//           itemBuilder: (context, index) {
//
//             final item = controller.requests[index];
//
//
//             return TweenAnimationBuilder<double>(
//
//               duration: Duration(
//                 milliseconds: 350 + (index * 100),
//               ),
//
//
//               tween: Tween(
//                 begin: 0,
//                 end: 1,
//               ),
//
//
//               builder: (context,value,child){
//
//
//                 return Opacity(
//
//                   opacity: value,
//
//
//                   child: Transform.translate(
//
//                     offset: Offset(
//                       0,
//                       30 * (1-value),
//                     ),
//
//
//                     child: child,
//
//                   ),
//
//                 );
//
//
//               },
//
//
//               child: GestureDetector(
//
//
//                 onTap: (){
//
//
//                   Get.to(
//
//                         ()=> RequestDetailsView(
//                       request: item,
//                     ),
//
//
//                     transition:
//                     Transition.rightToLeftWithFade,
//
//
//                     duration:
//                     const Duration(milliseconds:350),
//
//                   );
//
//
//                 },
//
//
//
//                 child: Container(
//
//                   margin: const EdgeInsets.only(
//                       bottom:16
//                   ),
//
//
//                   padding: const EdgeInsets.all(18),
//
//
//
//                   decoration: BoxDecoration(
//
//                     color: Theme.of(context).cardColor,
//
//
//                     borderRadius:
//                     BorderRadius.circular(22),
//
//
//
//                     boxShadow: [
//
//                       BoxShadow(
//
//                         color:
//                         Colors.black.withOpacity(.08),
//
//
//                         blurRadius:12,
//
//
//                         offset:
//                         const Offset(0,5),
//
//                       )
//
//                     ],
//
//
//                   ),
//
//
//
//                   child: Column(
//
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//
//
//                     children: [
//
//
//
//                       Row(
//
//                         children: [
//
//
//                           Container(
//
//                             height:45,
//
//                             width:45,
//
//
//                             decoration: BoxDecoration(
//
//                               color:
//                               AppColors.primary
//                                   .withOpacity(.12),
//
//
//                               shape:
//                               BoxShape.circle,
//
//                             ),
//
//
//
//                             child: Icon(
//
//                               item.type ==
//                                   "supervisor_leave"
//
//                                   ?
//
//                               Icons.event_busy
//
//                                   :
//
//                               Icons.swap_horiz,
//
//
//                               color:
//                               AppColors.primary,
//
//                             ),
//
//                           ),
//
//
//
//                           const SizedBox(width:14),
//
//
//
//
//                           Expanded(
//
//                             child:
//
//                             Text(
//
//                               item.title,
//
//
//                               maxLines:1,
//
//
//                               overflow:
//                               TextOverflow.ellipsis,
//
//
//                               style:
//
//                               const TextStyle(
//
//                                 fontSize:17,
//
//                                 fontWeight:
//                                 FontWeight.bold,
//
//                               ),
//
//                             ),
//
//                           ),
//
//
//
//                           _statusChip(
//                               item.status
//                           )
//
//
//                         ],
//
//                       ),
//
//
//
//
//                       const SizedBox(height:15),
//
//
//
//
//                       Text(
//
//                         item.description,
//
//
//                         maxLines:2,
//
//
//                         overflow:
//                         TextOverflow.ellipsis,
//
//
//                         style:
//
//                         TextStyle(
//
//                           fontSize:14,
//
//
//                           color:
//                           Theme.of(context).textTheme.bodyMedium?.color,
//
//                           height:1.4,
//
//                         ),
//
//
//                       ),
//
//
//
//
//                       const SizedBox(height:18),
//
//
//
//
//
//                       Row(
//
//                         children: [
//
//
//
//                           Container(
//
//                             padding:
//                             const EdgeInsets.symmetric(
//
//                               horizontal:12,
//
//                               vertical:7,
//
//                             ),
//
//
//
//                             decoration:
//
//                             BoxDecoration(
//
//                               color:
//
//                               AppColors.primary
//                                   .withOpacity(.10),
//
//
//                               borderRadius:
//                               BorderRadius.circular(20),
//
//                             ),
//
//
//
//                             child:
//
//                             Text(
//
//                               item.type
//                                   .replaceAll(
//                                   "_",
//                                   " "
//                               ),
//
//
//
//                               style:
//
//                               TextStyle(
//
//                                 color:
//                                 AppColors.primary,
//
//
//                                 fontSize:12,
//
//
//                                 fontWeight:
//                                 FontWeight.w600,
//
//                               ),
//
//                             ),
//
//
//                           ),
//
//
//
//
//                           const Spacer(),
//
//
//
//
//                           Icon(
//
//                             Icons.arrow_forward_ios,
//
//                             size:16,
//
//
//                             color:
//                             Theme.of(context).textTheme.bodySmall?.color,
//
//                           )
//
//                         ],
//
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       if (item.status == "pending")
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton.icon(
//                             onPressed: () {
//                               Get.dialog(
//                                 AlertDialog(
//                                   title: Text("Cancel Request"),
//                                   content: Text("Are you sure you want to cancel this request?"),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Get.back(),
//                                       child: Text("No"),
//                                     ),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Get.back();
//                                         controller.cancelRequest(item.id);
//                                       },
//                                       child: Text("Yes"),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             icon: Icon(Icons.cancel, color: Colors.red),
//                             label: Text(
//                               "Cancel Request",
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ),
//
//                     ],
//
//
//                   ),
//
//
//
//                 ),
//
//
//               ),
//
//             );
//
//           },
//
//         );
//       }),
//     );
//   }
//
//   Widget _emptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
//           SizedBox(height: 10),
//           Text(
//             "No Requests Yet",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 6),
//           Text("Create your first request",
//               style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
//           SizedBox(height: 20),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () {
//               Get.to(() => CreateRequestView());
//             },
//             child: Text("Create Request"),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _statusChip(String status) {
//     Color color;
//     String label;
//
//     switch (status) {
//       case 'pending':
//         color = Colors.orange;
//         label = "Pending";
//         break;
//
//       case 'approved':
//         color = Colors.green;
//         label = "Approved";
//         break;
//
//       case 'rejected':
//         color = Colors.red;
//         label = "Rejected";
//
//         break;
//
//       default:
//         color = Colors.grey;
//         label = status;
//     }
//
//     return Container(
//
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//
//     );
//   }
// }
//
//
// class CreateRequestView extends StatefulWidget {
//
//   CreateRequestView({super.key});
//
//   @override
//   State<CreateRequestView> createState() => _CreateRequestViewState();
// }
//
//
// class _CreateRequestViewState extends State<CreateRequestView> {
//
//   final shiftsController = Get.find<SupervisorShiftsController>();
//
//   final controller = Get.find<RequestController>();
//
//   final RxString selectedType = "supervisor_leave".obs;
//
//   final leaveDate = TextEditingController();
//
//   final reason = TextEditingController();
//
//   final description = TextEditingController();
//
//   int? selectedSupervisorId;
//   int? selectedShiftId;
//
//   final shiftDate = TextEditingController();
//
//   final fromHour = TextEditingController();
//
//   final toHour = TextEditingController();
//
//   final shiftDescription = TextEditingController();
//
//   ShiftType? selectedShiftType;
//
//   SupervisorShift? selectedShift;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         appBar: AppBar(
//           title: Text("Create Request"),
//           backgroundColor: AppColors.primary,
//         ),
//
//         body: SingleChildScrollView(
//
//           child: Padding(
//
//             padding: const EdgeInsets.all(16),
//
//             child: Column(
//
//               children: [
//
//
//                 /// TYPE SELECT
//                 Obx(() => DropdownButtonFormField(
//                   value: selectedType.value,
//                   items: [
//                     DropdownMenuItem(
//                       value: "supervisor_leave",
//                       child: Text("Leave Request"),
//                     ),
//                     DropdownMenuItem(
//                       value: "supervisor_shift_exchange",
//                       child: Text("Shift Exchange"),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     selectedType.value = value!;
//                   },
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                 )),
//
//                 SizedBox(height: 15),
//
//                 /// DYNAMIC FORM
//                 // Obx(() {
//                 //   return selectedType.value == "supervisor_leave"
//                 //       ? _leaveForm()
//                 //       : _shiftForm();
//                 // }),
//
//                 Obx(() {
//
//                   if(selectedType.value == "supervisor_leave"){
//
//                     return _leaveForm();
//
//                   }else{
//
//                     return _shiftForm();
//
//                   }
//
//                 }),
//
//                 SizedBox(height: 15),
//
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.all(14),
//                     ),
//                     onPressed: () async {
//                       await _submit();
//                     },
//                     child: Text("Submit Request"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
//
//   /// ================= LEAVE =================
//   Widget _leaveForm() {
//     return Column(
//       children: [
//         TextField(
//           controller: description,
//           maxLines: 3,
//           decoration: InputDecoration(
//             labelText: "Description",
//             border: OutlineInputBorder(),
//           ),
//         ),
//
//         SizedBox(height: 10),
//
//         TextField(
//           controller: leaveDate,
//           readOnly: true,
//           decoration: InputDecoration(
//             labelText: "Leave Date",
//             border: OutlineInputBorder(),
//             suffixIcon: Icon(Icons.calendar_today),
//           ),
//           onTap: () async {
//             DateTime? pickedDate = await showDatePicker(
//               context: context,
//               initialDate: DateTime.now(),
//               firstDate: DateTime(2020),
//               lastDate: DateTime(2035),
//             );
//
//             if (pickedDate != null) {
//               leaveDate.text =
//               "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//             }
//           },
//         ),
//
//         SizedBox(height: 10),
//
//         TextField(
//           controller: reason,
//           decoration: InputDecoration(
//             labelText: "Reason",
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
//   /// ================= SHIFT =================
//
//   Widget _shiftForm() {
//     return Column(
//       children: [
//
//         Obx(() {
//           if (controller.isLoadingSupervisors.value) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return DropdownButtonFormField<int>(
//             isExpanded: true,
//             value: selectedSupervisorId,
//
//             decoration: InputDecoration(
//               labelText: "Select Supervisor",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//
//             items: controller.supervisors
//                 .where((sup) => sup.id != controller.currentUserId)
//                 .map((sup) {
//               // items: controller.supervisors.map((sup) {
//               return DropdownMenuItem<int>(
//                 value: sup.id,
//                 child: Text("${sup.fullName} (${sup.specialization})"),
//               );
//             }).toList(),
//
//             onChanged: (value) {
//               setState(() {
//                 selectedSupervisorId = value;
//               });
//             },
//           );
//         }),
//
//         SizedBox(height: 10),
//
//         TextField(
//           controller: shiftDescription,
//           maxLines: 3,
//           decoration: InputDecoration(
//             labelText: "Description",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//
//
//         SizedBox(height: 10),
//
// /////////////////////////////////////////
//         DropdownButtonFormField<ShiftType>(
//
//           value: selectedShiftType,
//
//
//           decoration: InputDecoration(
//
//             labelText: "Shift Type",
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//
//           ),
//
//
//
//           items: const [
//
//
//             DropdownMenuItem(
//
//               value: ShiftType.lecture,
//
//               child: Text("Lecture"),
//
//             ),
//
//
//
//             DropdownMenuItem(
//
//               value: ShiftType.housing,
//
//               child: Text("Housing"),
//
//             ),
//
//
//           ],
//
//
//
//           onChanged: (value){
//
//             setState((){
//
//               selectedShiftType = value;
//
//               selectedShift = null;
//
//
//               shiftDate.clear();
//
//               fromHour.clear();
//
//               toHour.clear();
//
//             });
//
//
//             shiftsController.changeType(value!);
//
//           },
//
//         ),
//         //////////////////////////////////////////
//         SizedBox(height: 10),
//
//         Obx((){
//
//
//           final shifts =
//           shiftsController.shifts
//               .expand((day)=>day.shifts)
//               .toList();
//
//
//
//           return DropdownButtonFormField<SupervisorShift>(
//
//
//             value:selectedShift,
//
//
//             decoration: InputDecoration(
//
//               labelText:"Select Shift",
//
//               border:OutlineInputBorder(
//
//                 borderRadius:BorderRadius.circular(12),
//
//               ),
//
//             ),
//
//
//
//             items: shifts.map((shift){
//
//
//               return DropdownMenuItem<SupervisorShift>(
//
//
//                 value:shift,
//
//
//                 child:Text(
//
//                   "${shift.shiftDate.substring(0,10)} "
//                       "${shift.startTime} - ${shift.endTime}",
//
//                 ),
//
//
//               );
//
//
//             }).toList(),
//
//
//
//             onChanged:(value){
//
//               if(value == null) return;
//
//
//               setState((){
//
//                 selectedShift = value;
//
//
//                 shiftDate.text =
//                     value.shiftDate.substring(0,10);
//
//
//                 fromHour.text =
//                     value.startTime.substring(0,5);
//
//
//                 toHour.text =
//                     value.endTime.substring(0,5);
//
//
//               });
//
//             },
//
//
//
//           );
//
//
//         }),
//         ////////////////////////////////////////////////
//
//         SizedBox(height: 10),
//         TextField(
//           controller: shiftDate,
//
//           readOnly: true,
//
//           decoration: InputDecoration(
//             labelText: "Shift Date",
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//
//           ),
//         ),
//
//         SizedBox(height: 10),
//
//         TextField(
//           controller: fromHour,
//
//           readOnly: true,
//
//           decoration: InputDecoration(
//             labelText: "From Hour",
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//
//           ),
//         ),
//
//         SizedBox(height: 10),
//
//         TextField(
//           controller: toHour,
//
//           readOnly: true,
//
//           decoration: InputDecoration(
//             labelText: "To Hour",
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//
//           ),
//         ),
//
//
//       ],
//     );
//   }
//
//   /// ================= SUBMIT =================
//   Future<void> _submit() async {
//
//
//     if(selectedType.value == "supervisor_leave"){
//
//
//       await controller.createLeaveRequest(
//
//         date: leaveDate.text,
//
//         reason: reason.text,
//
//         description: description.text,
//
//       );
//
//
//     }else{
//
//
//       if(selectedSupervisorId == null){
//
//         Get.snackbar(
//           "Error",
//           "Please select supervisor",
//         );
//
//         return;
//
//       }
//
//
//       if(selectedShift == null){
//
//         Get.snackbar(
//           "Error",
//           "Please select shift",
//         );
//
//         return;
//
//       }
//
//
//
//       await controller.createShiftExchange(
//
//         targetSupervisorId: selectedSupervisorId!,
//
//
//         shiftId: selectedShift!.id,
//
//
//         date: shiftDate.text,
//
//
//         fromHour: fromHour.text,
//
//
//         toHour: toHour.text,
//
//
//         description: shiftDescription.text,
//
//       );
//
//     }
//
//
//     Get.back();
//
//   }
// }