import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/emergency_controller.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/view/emergency_details_view.dart';

class EmergencyView extends StatefulWidget {

  const EmergencyView({super.key});


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
        const Text("Emergency Cases"),

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

          return const Center(
            child:Text(
                "No Emergency Cases"
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
                      Colors.white,


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
                            Colors.grey[700],

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
                                  Colors.grey[600]

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
        const Text("New Emergency"),



        onPressed:() async {


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

        status,

        style:

        TextStyle(

            color:c,

            fontWeight:
            FontWeight.bold

        ),

      ),

    );


  }


  // ✅ داخل الكلاس
  void _showCreateSheet(BuildContext context) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 10),


                TextField(
                  controller: controller.severityController,
                  decoration: const InputDecoration(labelText: "severity"),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: controller.caseTypeController,
                  decoration: const InputDecoration(labelText: "case_type"),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.students.isEmpty) {
                    return const Center(
                      child: Text(
                          "Loading students..."
                      ),
                    );
                  }


                  return DropdownButtonFormField<StudentModel>(


                    isExpanded: true,


                    value:
                    controller.selectedStudent.value,


                    decoration:

                    InputDecoration(

                        labelText:
                        "Select Student",


                        border:
                        OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(15)

                        )

                    ),


                    items:


                    controller.students.map((student) {
                      return DropdownMenuItem<StudentModel>(


                        value:
                        student,


                        child:


                        Text(

                          "${student.fullName} - ${student.studentIdentifier}",

                          overflow:
                          TextOverflow.ellipsis,

                        ),


                      );
                    }).toList(),


                    onChanged: (value) {
                      controller.selectedStudent.value = value;


                      print(
                          "Selected ${value!.fullName}"
                      );
                    },


                  );
                }

                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    controller.createCase();
                  },
                  child: const Text("Send Emergency"),
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}