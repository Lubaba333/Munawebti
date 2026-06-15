// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supervisors/controller/RewardDetailsController.dart';
//
//
// class RewardDetailsView
//     extends StatelessWidget {
//
//   RewardDetailsView({super.key});
//
//   final controller =
//   Get.put(
//     RewardDetailsController(),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       appBar: AppBar(
//         title: const Text(
//           "تفاصيل المكافأة",
//         ),
//       ),
//
//       body: Obx(() {
//
//         if (controller.loading.value) {
//
//           return const Center(
//             child:
//             CircularProgressIndicator(),
//           );
//         }
//
//         final reward =
//             controller.reward.value;
//
//         if (reward == null) {
//
//           return const Center(
//             child: Text(
//               "لا يوجد بيانات",
//             ),
//           );
//         }
//
//         return Padding(
//           padding:
//           const EdgeInsets.all(16),
//
//           child: Column(
//
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//
//             children: [
//
//               Text(
//                 reward.title,
//                 style:
//                 const TextStyle(
//                   fontSize: 22,
//                   fontWeight:
//                   FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 20,
//               ),
//
//               Text(
//                 reward.description,
//                 style:
//                 const TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 20,
//               ),
//
//               Text(
//                 reward.createdAt
//                     .split('T')
//                     .first,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/RewardDetailsController.dart';
import 'package:supervisors/view/EditRewardView.dart';


class RewardDetailsView extends StatelessWidget {


  RewardDetailsView({
    super.key,
  });



  final controller =
  Get.put(
    RewardDetailsController(),
  );



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar: AppBar(

        title:
        const Text(
          "تفاصيل المكافأة",
        ),

        centerTitle:true,

        backgroundColor:
        AppColors.primary,

      ),



      body: Obx(() {


        if(controller.loading.value){

          return const Center(
            child:
            CircularProgressIndicator(),
          );

        }



        final reward =
            controller.reward.value;



        if(reward == null){

          return const Center(

            child:
            Text(
              "لا يوجد بيانات",
            ),

          );

        }



        return ListView(

          padding:
          const EdgeInsets.all(20),


          children: [



            _infoCard(

              "العنوان",

              reward.title,

            ),




            _infoCard(

              "الوصف",

              reward.description,

            ),




            _infoCard(

              "تاريخ الإنشاء",

              reward.createdAt
                  .split('T')
                  .first,

            ),





            const SizedBox(
              height:25,
            ),




            SizedBox(

              width:
              double.infinity,


              child:

              ElevatedButton.icon(

                icon:
                const Icon(
                  Icons.edit,
                ),


                label:
                const Text(
                  "تعديل المكافأة",
                ),


                style:

                ElevatedButton.styleFrom(


                  backgroundColor:
                  AppColors.primary,


                  padding:
                  const EdgeInsets.all(15),


                  shape:

                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),



                onPressed:(){


                  Get.to(

                        ()=>EditRewardView(

                      reward:
                      reward,

                    ),

                  );


                },


              ),

            )

          ],

        );


      }),


    );

  }







  Widget _infoCard(

      String title,

      String value,

      ){


    return Card(


      elevation:4,


      margin:
      const EdgeInsets.only(
        bottom:15,
      ),



      shape:

      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(18),

      ),




      child:

      Padding(

        padding:
        const EdgeInsets.all(18),



        child:

        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [



            Text(

              title,


              style:

              const TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:16,

              ),

            ),



            const SizedBox(
              height:8,
            ),



            Text(

              value,


              style:

              const TextStyle(

                fontSize:15,

              ),

            ),


          ],


        ),

      ),


    );

  }


}