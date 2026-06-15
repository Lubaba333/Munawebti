// import 'package:flutter/material.dart';
// import 'package:supervisors/models/StudentModel.dart';
//
// class StudentActionsSheet
//     extends StatelessWidget {
//
//   final StudentModel student;
//
//   const StudentActionsSheet({
//     super.key,
//     required this.student,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       padding:
//       const EdgeInsets.all(20),
//
//       decoration:
//       const BoxDecoration(
//         borderRadius:
//         BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//
//       child: Wrap(
//         children: [
//
//           ListTile(
//             leading:
//             const Icon(Icons.warning),
//             title:
//             const Text("إضافة تحذير"),
//             onTap: () {},
//           ),
//
//           ListTile(
//             leading:
//             const Icon(Icons.block),
//             title:
//             const Text("إضافة مخالفة"),
//             onTap: () {},
//           ),
//
//           ListTile(
//             leading:
//             const Icon(Icons.star),
//             title:
//             const Text("إضافة مكافأة"),
//             onTap: () {},
//           ),
//
//           ListTile(
//             leading:
//             const Icon(Icons.article),
//             title:
//             const Text("إضافة تقرير"),
//             onTap: () {},
//           ),
//
//           ListTile(
//             leading:
//             const Icon(Icons.emergency),
//             title:
//             const Text("حالة طارئة"),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }



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

      const BoxDecoration(

        borderRadius:

        BorderRadius.vertical(

          top: Radius.circular(25),

        ),

        color: Colors.white,

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