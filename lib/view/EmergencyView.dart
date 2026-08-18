import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/emergency_controller.dart';
import 'package:supervisors/view/emergency_details_view.dart';

class EmergencyView extends StatefulWidget {

   EmergencyView({super.key});


  @override
  State<EmergencyView> createState() =>
      _EmergencyViewState();

}



class _EmergencyViewState extends State<EmergencyView>{


  final controller =
  Get.find<EmergencyController>();


  @override
  void initState(){

    super.initState();

    controller.fetchCases();

  }




  @override
  Widget build(BuildContext context){


    return Scaffold(
      appBar: AppBar(

        title:
         Text("emergency_cases".tr),

        backgroundColor:
        AppColors.primary,

        centerTitle:true,

      ),



      body: Obx((){


        if(controller.isLoading.value){

          return const Center(
            child:CircularProgressIndicator(),
          );

        }



        if(controller.cases.isEmpty){

          return  Center(
            child:Text(
                "no_emergency_cases".tr
            ),
          );

        }




        return ListView.builder(


          padding:
          const EdgeInsets.all(16),


          itemCount:
          controller.cases.length,


          itemBuilder:(context,index){


            final item =
            controller.cases[index];



            return TweenAnimationBuilder(


              duration:
              Duration(milliseconds:400+index*100),


              tween:
              Tween<double>(
                  begin:0,
                  end:1
              ),


              builder:(context,value,child){


                return Opacity(

                  opacity:value,


                  child:
                  Transform.translate(

                    offset:
                    Offset(
                        0,
                        30*(1-value)
                    ),


                    child:child,

                  ),


                );


              },



              child:

              InkWell(


                onTap:(){

                  Get.to(

                        ()=>EmergencyDetailsView(

                        emergency:item

                    ),


                    transition:
                    Transition.rightToLeftWithFade,

                  );


                },


                child:


                Container(


                  margin:
                  const EdgeInsets.only(
                      bottom:18
                  ),


                  padding:
                  const EdgeInsets.all(18),


                  decoration:

                  BoxDecoration(


                      color:
                      Theme.of(context).cardColor,


                      borderRadius:
                      BorderRadius.circular(24),


                      boxShadow:[


                        BoxShadow(

                            color:
                            Colors.black12,

                            blurRadius:10,

                            offset:
                            Offset(0,5)

                        )

                      ]


                  ),



                  child:Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[



                      Row(

                        children:[


                          Container(

                            padding:
                            const EdgeInsets.all(12),

                            decoration:
                            BoxDecoration(

                                color:
                                Colors.red.withOpacity(.1),

                                shape:
                                BoxShape.circle

                            ),


                            child:
                            const Icon(
                              Icons.warning,
                              color:Colors.red,
                            ),

                          ),



                          const SizedBox(width:12),



                          Expanded(

                            child:

                            Text(

                              item.title,

                              style:
                              const TextStyle(

                                  fontSize:18,

                                  fontWeight:
                                  FontWeight.bold

                              ),

                            ),

                          ),



                          _status(item.status)


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

                            color:
                            Theme.of(context).textTheme.bodyMedium?.color,

                            fontSize:14

                        ),

                      ),



                      const SizedBox(height:15),



                      Divider(),



                      Row(

                          children:[


                            const Icon(

                              Icons.person,

                              size:18,

                              color:
                              Colors.blue,

                            ),


                            const SizedBox(width:8),


                            Text(
                                item.student.fullName
                            ),


                            const Spacer(),


                            Text(

                              item.student.specialization,

                              style:
                              TextStyle(

                                  fontSize:12,

                                  color:
                                  Theme.of(context).textTheme.bodySmall?.color

                              ),

                            )

                          ]


                      ),



                    ],


                  ),


                ),


              ),


            );


          },

        );


      }),




      floatingActionButton:

      FloatingActionButton.extended(


        backgroundColor:
        AppColors.primary,


        icon:
        const Icon(Icons.add),


        label:
         Text("new_emergency".tr),


        onPressed: () async {

          controller.clearCreateForm();

          await controller.fetchStudents();

          _showCreateSheet(context);
        },


      ),


    );


  }







  Widget _status(String status){


    Color c;


    switch(status){

      case "pending":
        c=Colors.orange;
        break;


      case "approved":
        c=Colors.green;
        break;


      default:
        c=Colors.red;

    }



    return Container(

      padding:
      const EdgeInsets.symmetric(
          horizontal:12,
          vertical:6
      ),


      decoration:

      BoxDecoration(

          color:c.withOpacity(.15),

          borderRadius:
          BorderRadius.circular(20)

      ),


      child:

      Text(

        _translatedStatus(status),

        style:

        TextStyle(

            color:c,

            fontWeight:
            FontWeight.bold

        ),

      ),

    );


  }

  String _translatedStatus(String status) {
    switch (status) {
      case "pending":
        return "pending".tr;
      case "approved":
        return "approved".tr;
      case "rejected":
        return "rejected".tr;
      default:
        return status;
    }
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color:AppColors.primary ),
      ),
    );
  }




  void _showCreateSheet(BuildContext context) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.titleController,
                  decoration: buildInputDecoration("title".tr),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: controller.descriptionController,
                  decoration: buildInputDecoration("description".tr),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: controller.severityController,
                  decoration: buildInputDecoration("severity".tr),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: controller.caseTypeController,
                  decoration: buildInputDecoration("case_type".tr),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.students.isEmpty) {
                    return  Center(
                      child: Text("loading_students".tr),
                    );
                  }

                  return DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: controller.students.any(
                            (s) => s.id == controller.selectedStudent.value?.id)
                        ? controller.selectedStudent.value?.id
                        : null,
                    decoration: buildInputDecoration("select_student".tr),
                    items: controller.students.map((student) {
                      return DropdownMenuItem<int>(
                        value: student.id,
                        child: Text(
                          "${student.fullName} - ${student.studentIdentifier}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      final match = controller.students
                          .where((s) => s.id == id);

                      controller.selectedStudent.value =
                      match.isNotEmpty ? match.first : null;

                      if (controller.selectedStudent.value != null) {
                        print(
                            "Selected ${controller.selectedStudent.value!.fullName}");
                      }
                    },
                  );
                }),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      controller.createCase();
                    },
                    child:  Text("send_emergency".tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}









//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supervisors/const/app_colors.dart';
// import 'package:supervisors/controller/emergency_controller.dart';
// import 'package:supervisors/models/StudentModel.dart';
// import 'package:supervisors/view/emergency_details_view.dart';
//
// class EmergencyView extends StatefulWidget {
//   const EmergencyView({super.key});
//
//   @override
//   State<EmergencyView> createState() => _EmergencyViewState();
// }
//
// class _EmergencyViewState extends State<EmergencyView> {
//   final controller = Get.find<EmergencyController>();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchCases();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//         return Scaffold(
//       appBar: AppBar(
//
//         title:
//         const Text("Emergency Cases"),
//
//         backgroundColor:
//         AppColors.primary,
//
//         centerTitle:true,
//
//       ),
//
//         body: SafeArea(
//             child: Obx(() {
//
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               if (controller.cases.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.inbox_outlined,
//                         size: 70,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "No Emergency Cases",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               }
//
//               return ListView(
//                 padding: const EdgeInsets.all(6),
//
//                 children: [
//
//                 SizedBox(
//                 width: double.infinity,
//                 child:Container(
//
//                     width: double.infinity,
//
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 12,
//                   ),
//
//                     decoration: BoxDecoration(
//
//                       color: Colors.white,
//
//                       borderRadius: BorderRadius.circular(18),
//
//                       boxShadow: [
//
//                         BoxShadow(
//
//                           color: Colors.black.withOpacity(.05),
//
//                           blurRadius: 12,
//
//                           offset: const Offset(0, 4),
//
//                         )
//
//                       ],
//
//                     ),
//
//                     child: ListView.separated(
//
//                         shrinkWrap: true,
//
//                         physics: const NeverScrollableScrollPhysics(),
//
//                         itemCount: controller.cases.length,
//
//                         separatorBuilder: (_, __) => Divider(
//                           height: 1,
//                           color: Colors.grey.shade200,
//                           indent: 70,
//                           endIndent: 20,
//                         ),
//
//                   itemBuilder: (context, index) {
//
//                     final item = controller.cases[index];
//
//                     return InkWell(
//
//                       onTap: () {
//
//                         Get.to(
//                               () => EmergencyDetailsView(emergency: item),
//                           transition: Transition.rightToLeftWithFade,
//                         );
//
//                       },
//
//                       child: Container(
//
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 18,
//                           vertical: 16,
//                         ),
//
//                         child: Row(
//
//                           children: [
//
//                             CircleAvatar(
//
//                               radius: 24,
//
//                               backgroundColor: Colors.red.shade50,
//
//                               child: const Icon(
//                                 Icons.warning_amber_rounded,
//                                 color: Colors.red,
//                                 size: 28,
//                               ),
//
//                             ),
//
//                             const SizedBox(width: 16),
//
//                             Expanded(
//
//                               child: Column(
//
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//
//                                 children: [
//
//                                   Row(
//
//                                     children: [
//
//                                       Expanded(
//
//                                         child: Text(
//
//                                           item.title,
//
//                                           style: const TextStyle(
//
//                                             fontSize: 18,
//
//                                             fontWeight: FontWeight.bold,
//
//                                           ),
//
//                                         ),
//
//                                       ),
//
//                                       _status(item.status),
//
//                                     ],
//
//                                   ),
//
//                                   const SizedBox(height: 6),
//
//                                   Text(
//
//                                     item.description,
//
//                                     maxLines: 2,
//
//                                     overflow: TextOverflow.ellipsis,
//
//                                     style: TextStyle(
//
//                                       color: Colors.grey,
//
//                                       fontSize: 14,
//
//                                     ),
//
//                                   ),
//
//                                   const SizedBox(height: 12),
//
//                                   Row(
//
//                                     children: [
//
//                                       Icon(
//                                         Icons.person_outline,
//                                         size: 18,
//                                         color: Colors.grey.shade600,
//                                       ),
//
//                                       const SizedBox(width: 6),
//
//                                       Expanded(
//
//                                         child: Text(
//
//                                           item.student.fullName,
//
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                           ),
//
//                                         ),
//
//                                       ),
//
//                                       Text(
//
//                                         item.student.specialization,
//
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                           fontSize: 13,
//                                         ),
//
//                                       ),
//
//                                     ],
//
//                                   ),
//
//                                 ],
//
//                               ),
//
//                             ),
//
//                             const SizedBox(width: 8),
//
//                             Icon(
//                               Icons.chevron_right,
//                               color: Colors.grey.shade400,
//                             ),
//
//                           ],
//
//                         ),
//
//                       ),
//
//                     );
//
//                   }
//               ),
//
//               ),
//
//                 ), ],
//
//               );
//
//             }),
//
//         ),
//
//       floatingActionButton: FloatingActionButton.extended(
//
//         elevation: 0,
//
//         backgroundColor: AppColors.primary,
//
//         foregroundColor: Colors.white,
//
//         icon: const Icon(Icons.add),
//
//         label: const Text(
//
//           "New Emergency",
//
//           style: TextStyle(
//
//             fontWeight: FontWeight.bold,
//
//           ),
//
//         ),
//
//         onPressed: () async {
//
//           await controller.fetchStudents();
//
//           _showCreateSheet(context);
//
//         },
//
//       ),
//
//     );
//
//   }
//   Widget _status(String status) {
//
//     Color color;
//     IconData icon;
//
//     switch (status.toLowerCase()) {
//
//       case "pending":
//         color = Colors.orange;
//         icon = Icons.schedule_rounded;
//         break;
//
//       case "approved":
//         color = Colors.green;
//         icon = Icons.check_circle_rounded;
//         break;
//
//       case "rejected":
//         color = Colors.red;
//         icon = Icons.cancel_rounded;
//         break;
//
//       default:
//         color = Colors.blueGrey;
//         icon = Icons.info_outline_rounded;
//     }
//
//     return Container(
//
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 7,
//       ),
//
//       decoration: BoxDecoration(
//
//         color: color.withOpacity(.12),
//
//         borderRadius: BorderRadius.circular(30),
//
//       ),
//
//       child: Row(
//
//         mainAxisSize: MainAxisSize.min,
//
//         children: [
//
//           Icon(
//             icon,
//             size: 15,
//             color: color,
//           ),
//
//           const SizedBox(width: 5),
//
//           Text(
//
//             status,
//
//             style: TextStyle(
//
//               color: color,
//
//               fontSize: 12,
//
//               fontWeight: FontWeight.w700,
//
//             ),
//
//           ),
//
//         ],
//
//       ),
//
//     );
//
//   }
//   void _showCreateSheet(BuildContext context) {
//
//     Get.bottomSheet(
//
//         SingleChildScrollView(
//
//             child: Padding(
//
//               padding: EdgeInsets.only(
//
//                 left: 20,
//                 right: 20,
//                 top: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//
//               ),
//
//               child: Container(
//
//                 decoration: const BoxDecoration(
//
//                   color: Colors.white,
//
//                   borderRadius: BorderRadius.vertical(
//
//                     top: Radius.circular(30),
//
//                   ),
//
//                 ),
//
//                 child: Column(
//
//                   mainAxisSize: MainAxisSize.min,
//
//                   crossAxisAlignment: CrossAxisAlignment.start,
//
//                   children: [
//
//                 Center(
//
//                 child: Container(
//
//                 width: 55,
//
//                   height: 5,
//
//                   decoration: BoxDecoration(
//
//                     color: Colors.grey.shade300,
//
//                     borderRadius: BorderRadius.circular(20),
//
//                   ),
//
//                 ),
//
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text(
//
//                 "Create Emergency",
//
//                 style: TextStyle(
//
//                   fontSize: 24,
//
//                   fontWeight: FontWeight.bold,
//
//                 ),
//
//               ),
//
//               const SizedBox(height: 25),
//
//               TextField(
//
//                 controller: controller.titleController,
//
//                 decoration: InputDecoration(
//
//                   labelText: "Title",
//
//                   prefixIcon: const Icon(Icons.title),
//
//                   filled: true,
//
//                   fillColor: Colors.grey.shade100,
//
//                   border: OutlineInputBorder(
//
//                     borderRadius: BorderRadius.circular(16),
//
//                     borderSide: BorderSide.none,
//
//                   ),
//
//                 ),
//
//               ),
//
//               const SizedBox(height: 16),
//
//               TextField(
//
//                 controller: controller.descriptionController,
//
//                 maxLines: 3,
//
//                 decoration: InputDecoration(
//
//                   labelText: "Description",
//
//                   alignLabelWithHint: true,
//
//                   // prefixIcon: const Padding(
//                   //
//                   //   padding: EdgeInsets.only(bottom: 60),
//                   //
//                   //   child: Icon(Icons.description_outlined),
//                   //
//                   // ),
//
//                   filled: true,
//
//                   fillColor: Colors.grey.shade100,
//
//                   border: OutlineInputBorder(
//
//                     borderRadius: BorderRadius.circular(16),
//
//                     borderSide: BorderSide.none,
//
//                   ),
//
//                 ),
//
//               ),
//
//               const SizedBox(height: 16),
//
//               Row(
//
//                 children: [
//
//                   Expanded(
//
//                     child: TextField(
//
//                       controller: controller.severityController,
//
//                       decoration: InputDecoration(
//
//                         labelText: "Severity",
//
//                         prefixIcon: const Icon(Icons.priority_high),
//
//                         filled: true,
//
//                         fillColor: Colors.grey.shade100,
//
//                         border: OutlineInputBorder(
//
//                           borderRadius: BorderRadius.circular(16),
//
//                           borderSide: BorderSide.none,
//
//                         ),
//
//                       ),
//
//                     ),
//
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   Expanded(
//
//                     child: TextField(
//
//                       controller: controller.caseTypeController,
//
//                       decoration: InputDecoration(
//
//                         labelText: "Case Type",
//
//                         prefixIcon: const Icon(Icons.category),
//
//                         filled: true,
//
//                         fillColor: Colors.grey.shade100,
//
//                         border: OutlineInputBorder(
//
//                           borderRadius: BorderRadius.circular(16),
//
//                           borderSide: BorderSide.none,
//
//                         ),
//
//                       ),
//
//                     ),
//
//                   ),
//
//                 ],
//
//               ),
//
//               const SizedBox(height: 18),
//                     Obx(() {
//
//                       if (controller.students.isEmpty) {
//                         return Container(
//                           padding: const EdgeInsets.all(16),
//                           alignment: Alignment.center,
//                           child: const CircularProgressIndicator(),
//                         );
//                       }
//
//                       return DropdownButtonFormField<StudentModel>(
//
//                         value: controller.selectedStudent.value,
//
//                         isExpanded: true,
//
//                         decoration: InputDecoration(
//
//                           labelText: "Student",
//
//                           prefixIcon: const Icon(Icons.school_outlined),
//
//                           filled: true,
//
//                           fillColor: Colors.grey.shade100,
//
//                           border: OutlineInputBorder(
//
//                             borderRadius: BorderRadius.circular(16),
//
//                             borderSide: BorderSide.none,
//
//                           ),
//
//                         ),
//
//                         items: controller.students.map((student) {
//
//                           return DropdownMenuItem<StudentModel>(
//
//                             value: student,
//
//                             child: Text(
//                               "${student.fullName} • ${student.studentIdentifier}",
//                               overflow: TextOverflow.ellipsis,
//                             ),
//
//                           );
//
//                         }).toList(),
//
//                         onChanged: (student) {
//
//                           controller.selectedStudent.value = student;
//
//                         },
//
//                       );
//
//                     }),
//
//                     const SizedBox(height: 28),
//
//                     SizedBox(
//
//                       width: double.infinity,
//
//                       height: 55,
//
//                       child: ElevatedButton.icon(
//
//                         style: ElevatedButton.styleFrom(
//
//                           backgroundColor: AppColors.primary,
//
//                           foregroundColor: Colors.white,
//
//                           elevation: 0,
//
//                           shape: RoundedRectangleBorder(
//
//                             borderRadius: BorderRadius.circular(16),
//
//                           ),
//
//                         ),
//
//                         icon: const Icon(Icons.send_rounded),
//
//                         label: const Text(
//
//                           "Send Emergency",
//
//                           style: TextStyle(
//
//                             fontSize: 16,
//
//                             fontWeight: FontWeight.bold,
//
//                           ),
//
//                         ),
//
//                         onPressed: () {
//
//                           controller.createCase();
//
//                         },
//
//                       ),
//
//                     ),
//
//                     const SizedBox(height: 10),
//
//                   ],
//
//                 ),
//
//               ),
//
//             ),
//
//         ),
//
//       isScrollControlled: true,
//
//       backgroundColor: Colors.transparent,
//
//     );
//
//   }
//
// }