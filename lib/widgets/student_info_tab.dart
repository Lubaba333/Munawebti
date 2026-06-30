import 'package:flutter/material.dart';
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

      padding: const EdgeInsets.all(20),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
          
          _infoRow(

            icon:Icons.badge,

            title:"الرقم الجامعي",

            value:student.studentIdentifier,

          ),



          _infoRow(

            icon:Icons.school,

            title:"الاختصاص",

            value:student.specialization,

          ),



          _infoRow(

            icon:Icons.email,

            title:"البريد",

            value:student.email,

          ),



          _infoRow(

            icon:Icons.phone,

            title:"الهاتف",

            value:student.phoneNumber,

          ),



          _infoRow(

            icon:Icons.layers,

            title:"السنة",

            value:student.year.toString(),

          ),



          _infoRow(

            icon:Icons.home,

            title:"السكن",

            value:student.isResident
                ? "مقيم"
                : "غير مقيم",

          ),


        ],

      ),

    );

  }




  Widget _infoRow({

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

            color:Colors.grey.shade200,

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

                    color:Colors.grey.shade600,

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