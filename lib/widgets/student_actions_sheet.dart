import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/models/StudentModel.dart';
import 'package:supervisors/view/student_action_dialog.dart';

class StudentActionsSheet
    extends StatelessWidget {


  final StudentModel student;


  const StudentActionsSheet({

    super.key,

    required this.student,

  });



  void openDialog(
      StudentActionType type
      ){

    Get.back();


    Get.dialog(

      StudentActionDialog(

        studentId: student.id,

        type: type,

      ),

    );

  }




  @override
  Widget build(BuildContext context) {


    return Container(

      padding:
      const EdgeInsets.all(20),


      decoration:

      BoxDecoration(

        borderRadius:

        const BorderRadius.vertical(

          top: Radius.circular(25),

        ),

        color: Theme.of(context).cardColor,

      ),


      child: Wrap(

        children: [



          ListTile(

            leading:

            const Icon(

              Icons.warning,

              color: Colors.orange,

            ),

            title:

            const Text(

              "إضافة تحذير",

            ),


            onTap: () {

              openDialog(

                StudentActionType.warning,

              );

            },


          ),





          ListTile(

            leading:

            const Icon(

              Icons.block,

              color: Colors.red,

            ),


            title:

            const Text(

              "إضافة مخالفة",

            ),


            onTap: () {

              openDialog(

                StudentActionType.violation,

              );

            },


          ),





          ListTile(

            leading:

            const Icon(

              Icons.star,

              color: Colors.amber,

            ),


            title:

            const Text(

              "إضافة مكافأة",

            ),



            onTap: () {


              openDialog(

                StudentActionType.reward,

              );


            },

          ),





          ListTile(

            leading:

            const Icon(

              Icons.article,

            ),


            title:

            const Text(

              "إضافة تقرير",

            ),



            onTap: () {


              openDialog(

                StudentActionType.report,

              );


            },


          ),



        ],

      ),

    );


  }

}