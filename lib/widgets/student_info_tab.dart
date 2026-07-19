import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/models/StudentModel.dart';

class StudentInfoTab extends StatelessWidget {

  final StudentModel student;


  const StudentInfoTab({
    super.key,
    required this.student,
  });



  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(

      padding:  EdgeInsets.all(20),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
          
          _infoRow(

            context: context,

            icon:Icons.badge,

            title:"student_id".tr,

            value:student.studentIdentifier,

          ),



          _infoRow(

            context: context,

            icon:Icons.school,

            title:"specialization".tr,

            value:student.specialization,

          ),



          _infoRow(

            context: context,

            icon:Icons.email,

            title:"email".tr,

            value:student.email,

          ),



          _infoRow(

            context: context,

            icon:Icons.phone,

            title:"phone".tr,

            value:student.phoneNumber,

          ),



          _infoRow(

            context: context,

            icon:Icons.layers,

            title:"year".tr,

            value:student.year.toString(),

          ),



          _infoRow(

            context: context,

            icon:Icons.home,

            title:"residency".tr,

            value:student.isResident
                ? "resident".tr
                : "non_resident".tr,

          ),


        ],

      ),

    );

  }




  Widget _infoRow({

    required BuildContext context,

    required IconData icon,

    required String title,

    required String value,


  }){


    return Container(

      padding: const EdgeInsets.symmetric(
        vertical:16,
      ),


      decoration: BoxDecoration(

        border: Border(

          bottom: BorderSide(

            color:Theme.of(context).dividerColor,

          ),

        ),

      ),


      child: Row(


        children: [


          Container(

            padding:const EdgeInsets.all(10),

            decoration:BoxDecoration(

              color:
              AppColors.primary.withOpacity(.08),

              shape:BoxShape.circle,

            ),


            child:Icon(

              icon,

              size:20,

              color:AppColors.primary,

            ),

          ),



          const SizedBox(width:15),




          Expanded(

            child:Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[


                Text(

                  title,

                  style:TextStyle(

                    color:Theme.of(context).textTheme.bodySmall?.color,

                    fontSize:13,

                  ),

                ),



                const SizedBox(height:4),



                Text(

                  value.isEmpty
                      ? "-"
                      : value,


                  style:const TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.w600,

                  ),

                ),


              ],


            ),

          )


        ],

      ),

    );


  }

}