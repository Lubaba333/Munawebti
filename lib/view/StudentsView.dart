import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/StudentsController.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/view/StudentDetailsView.dart';


class StudentsView extends GetView<StudentsController> {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          controller.loadStudents(refresh: true);
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StudentsSearchBar(
                controller: controller.searchController,
                onChanged: controller.searchStudents,
              ),

              const SizedBox(height: 16),

              Row(
                children: [

                  Expanded(
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedFilter.value,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "all",
                         // child: Text("all".tr),
                          child: Text("all".tr, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: "resident",
                         // child: Text("resident".tr),
                          child: Text("resident".tr, overflow: TextOverflow.ellipsis),
                        ),
                        DropdownMenuItem(
                          value: "non_resident",
                         // child: Text("non_resident".tr),
                          child: Text("non_resident".tr, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                      onChanged: (value) {
                        controller.changeFilter(value!);
                      },
                    )),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedYear.value,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(value: "all", child: Text("All_Years".tr, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: "1", child: Text('first_year'.tr, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: "2", child: Text('second_year'.tr, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: "3", child: Text('third_year'.tr, overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: "4", child: Text('fourth_year'.tr, overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: controller.selectedFilter.value == "all"
                          ? null
                          : (value) {
                        controller.changeYear(value!);
                      },
                    )),
                  ),

                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.changeFilter("all");
                      controller.changeYear("all");
                    },
                  ),
                ],
              ),


              const SizedBox(height: 18),

              /// LIST
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.students.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.filteredStudents.isEmpty) {
                    return Center(
                      child: Text('no_students'.tr),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.loadStudents(refresh: true),
                    child: ListView.builder(
                      itemCount: controller.filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = controller.filteredStudents[index];

                        return StudentCard(
                          student: student,
                          onTap: () {
                            Get.to(
                                  () =>  StudentDetailsView(),
                              arguments: student,
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CHIP FILTER
  Widget _chip(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.selectedFilter.value == value;

        return ChoiceChip(
          label: Text(title),
          selected: selected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onSelected: (_) => controller.changeFilter(value),
        );
      }),
    );
  }


  Widget _yearChip(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.selectedYear.value == value;

        return ChoiceChip(
          label: Text(title),
          selected: selected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onSelected: (_) => controller.changeYear(value),
        );
      }),
    );
  }
}



class StudentCard extends StatefulWidget {

  final StudentModel student;
  final VoidCallback onTap;


  const StudentCard({

    super.key,

    required this.student,

    required this.onTap,

  });


  @override
  State<StudentCard> createState() => _StudentCardState();

}




class _StudentCardState extends State<StudentCard> {


  bool pressed = false;



  void _changePressed(bool value){

    if(mounted){

      setState(() {

        pressed = value;

      });

    }

  }



  @override
  Widget build(BuildContext context) {


    final student = widget.student;



    return AnimatedContainer(

      duration: const Duration(milliseconds:150),


      curve: Curves.easeOut,


      color: pressed

          ? AppColors.primary.withOpacity(0.12)

          : Theme.of(context).cardColor,



      child: InkWell(


       splashColor: AppColors.primary.withOpacity(.15),

        highlightColor: Colors.transparent,

        onTapDown: (_) {


          _changePressed(true);


        },


        onTapCancel: (){


          _changePressed(false);


        },


        onTapUp: (_) async {


          _changePressed(true);



          await Future.delayed(
              const Duration(milliseconds:120)
          );


          _changePressed(false);



          widget.onTap();


        },



        child: Container(


          padding: const EdgeInsets.symmetric(

            horizontal:16,

            vertical:12,

          ),


          child: Row(


            children: [



              Container(


                width:52,

                height:52,


                decoration:BoxDecoration(


                  shape:BoxShape.circle,


                 color:AppColors.primary.withOpacity(.12),


                ),



                child:Icon(

                  Icons.person,

                  color:AppColors.primary,

                ),


              ),




              const SizedBox(width:14),




              Expanded(


                child:Column(


                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[



                    Text(

                      student.fullName,


                      style:const TextStyle(

                        fontSize:16,

                        fontWeight:FontWeight.w600,

                      ),

                    ),


                    const SizedBox(height:3),




                    Text(

                      student.specialization,


                      style:TextStyle(

                        fontSize:13,

                        color:Theme.of(context).textTheme.bodySmall?.color,

                      ),

                    ),



                  ],


                ),


              ),





              _status(student),



              const SizedBox(width:10),




              Icon(

                Icons.arrow_forward_ios,

                size:15,

                color:Theme.of(context).textTheme.bodySmall?.color,

              )



            ],


          ),


        ),


      ),


    );


  }





  Widget _status(StudentModel student){


    return Container(


      padding:const EdgeInsets.symmetric(

        horizontal:10,

        vertical:5,

      ),




      decoration:BoxDecoration(


        color: student.isResident


            ? Colors.green.withOpacity(.15)

            : Colors.orange.withOpacity(.15),



        borderRadius:BorderRadius.circular(20),


      ),




      child:Text(


        student.isResident

            ? "resident".tr

            : "non_resident".tr,



        style:TextStyle(


          fontSize:12,


          color: student.isResident

              ? Colors.green

              : Colors.orange,


          fontWeight:FontWeight.bold,


        ),


      ),


    );


  }


}



class StudentsSearchBar extends StatelessWidget {
    final TextEditingController controller;
    final Function(String) onChanged;

  const StudentsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
      }
    );

    @override
    Widget build(BuildContext context) {
return TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
    hintText: 'search_student'.tr,
    prefixIcon: const Icon(Icons.search),
    filled: true,
    fillColor: Theme.of(context).cardColor,
       contentPadding: const EdgeInsets.symmetric(vertical: 16),
         border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(18),
         borderSide: BorderSide.none,
         ),
       ),
      );
       }
    }