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

              /// Filters
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _chip('الكل', 'all'),
                    _chip('مقيم', 'resident'),
                    _chip('غير مقيم', 'non_resident'),
                  ],
                ),
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
                    return const Center(
                      child: Text('لا يوجد طلاب'),
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
  Widget _chip(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final selected = controller.selectedFilter.value == value;

        return ChoiceChip(
          label: Text(title),
          selected: selected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (_) => controller.changeFilter(value),
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

          : Colors.white,



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



          decoration: BoxDecoration(


            border: Border(

              bottom: BorderSide(

                color: Colors.grey.shade200,

              ),

            ),


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

                        color:Colors.grey.shade600,

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

                color:Colors.grey.shade500,

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

            ? "مقيم"

            : "غير مقيم",



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

            ? "مقيم"

            : "غير مقيم",


        style:TextStyle(

          fontSize:12,

          color:student.isResident

              ? Colors.green

              : Colors.orange,


          fontWeight:FontWeight.bold,

        ),

      ),

    );


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
    hintText: 'ابحث عن طالب...',
    prefixIcon: const Icon(Icons.search),
    filled: true,
    fillColor: AppColors.white,
       contentPadding: const EdgeInsets.symmetric(vertical: 16),
         border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(18),
         borderSide: BorderSide.none,
         ),
       ),
      );
       }
    }