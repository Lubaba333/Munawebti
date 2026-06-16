// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supervisors/controller/RewardsController.dart';
// import 'package:supervisors/models/RewardModel.dart';
// import 'package:supervisors/view/RewardDetailsView.dart';
//
//
//
//
// class EditRewardView extends StatefulWidget{
//
//
//   final RewardModel reward;
//
//
//   const EditRewardView({
//
//     super.key,
//
//     required this.reward
//
//   });
//
//
//   @override
//   State<EditRewardView> createState()
//   =>_EditRewardViewState();
//
//
// }
//
//
//
// class _EditRewardViewState
//     extends State<EditRewardView>{
//
//
//
//   final controller =
//   Get.find<RewardsController>();
//
//
//
//   late TextEditingController title;
//   late TextEditingController description;
//   late TextEditingController date;
//
//
//
//
//   @override
//   void initState(){
//
//     super.initState();
//
//
//
//
//
//     title=
//         TextEditingController(
//             text:widget.reward.title
//         );
//
//
//     description=
//         TextEditingController(
//             text:widget.reward.description
//         );
//
//
//     date=
//         TextEditingController(
//             text:widget.reward.createdAt
//         );
//
//
//
//
//
//   }
//
//
//
//   @override
//   Widget build(BuildContext context){
//
//
//     return Scaffold(
//
//
//         appBar:
//         AppBar(
//
//           title:
//           const Text(
//               "تعديل المكافأة"
//           ),
//
//         ),
//
//
//         body:Padding(
//
//           padding:
//           const EdgeInsets.all(20),
//
//
//           child:Column(
//
//               children:[
//
//
//
//
//
//
//                 _field(title,"العنوان"),
//
//
//                 _field(description,"الوصف"),
//
//
//                 _field(date,"التاريخ"),
//
//
//
//
//
//
//                 const SizedBox(height:25),
//
//
//
//                 Obx(()=>ElevatedButton(
//
//
//                   onPressed:
//
//                   controller.loading.value
//
//                       ?null
//
//                       :
//
//                       ()async{
//
//
//                     bool success =
//                     await controller.updateReward(
//
//
//                       rewardId:
//                       widget.reward.id,
//
//
//
//                       title:
//                       title.text,
//
//
//                       description:
//                       description.text,
//
//
//                       rewardDate:
//                       date.text,
//
//
//                     );
//
//
//
//                     if(success){
//
//                       Get.off(
//                               ()=>RewardDetailsView(),
//                         arguments: widget.reward.id,
//                       );
//
//                     }
//
//
//
//                   },
//
//
//                   child:
//                   controller.loading.value
//
//                       ?
//                   const CircularProgressIndicator()
//
//                       :
//                   const Text(
//                       "حفظ"
//                   ),
//
//
//                 ))
//
//
//
//
//               ]
//
//           ),
//
//
//         )
//
//     );
//
//   }
//
//
//
//   Widget _field(
//       TextEditingController c,
//       String label
//
//       ){
//
//     return Padding(
//
//       padding:
//       const EdgeInsets.only(
//           bottom:12
//       ),
//
//       child:TextField(
//
//         controller:c,
//
//
//         decoration:
//         InputDecoration(
//
//             labelText:label,
//
//             border:
//             const OutlineInputBorder()
//
//         ),
//
//       ),
//
//     );
//
//   }
//
//
//
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/RewardsController.dart';
import 'package:supervisors/models/RewardModel.dart';
import 'package:supervisors/view/RewardDetailsView.dart';



class EditRewardView extends StatefulWidget {


  final RewardModel reward;


  const EditRewardView({

    super.key,

    required this.reward,

  });



  @override
  State<EditRewardView> createState()
  => _EditRewardViewState();



}





class _EditRewardViewState
    extends State<EditRewardView>{



  final controller =
  Get.find<RewardsController>();



  late TextEditingController title;

  late TextEditingController description;

  late TextEditingController date;




  @override
  void initState(){


    super.initState();



    title =
        TextEditingController(

          text:
          widget.reward.title,

        );



    description =
        TextEditingController(

          text:
          widget.reward.description,

        );



    date =
        TextEditingController(

          text:
          widget.reward.createdAt.split('T').first,

        );


  }





  @override
  void dispose(){


    title.dispose();

    description.dispose();

    date.dispose();


    super.dispose();

  }







  @override
  Widget build(BuildContext context){



    return Scaffold(



      backgroundColor:
      Colors.grey[100],




      appBar: AppBar(


        title:

        const Text(

          "تعديل المكافأة",

        ),


        centerTitle:true,


        backgroundColor:

        AppColors.primary,



      ),





      body:


      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),





        child:

        Column(



          children:[





            _field(

              title,

              "العنوان",

            ),





            _field(

              description,

              "الوصف",

              maxLines:4,

            ),





            _field(

              date,

              "تاريخ المكافأة",

            ),





            const SizedBox(

              height:30,

            ),





            Obx(



                    ()=> SizedBox(



                  width:

                  double.infinity,




                  child:

                  ElevatedButton(




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





                    onPressed:

                    controller.loading.value

                        ? null


                        : () async {



                      bool success =



                      await controller.updateReward(



                        rewardId:

                        widget.reward.id,



                        title:

                        title.text.trim(),



                        description:

                        description.text.trim(),



                        rewardDate:

                        date.text.trim(),



                      );





                      if(success){



                        Get.off(


                              ()=>RewardDetailsView(),



                          arguments:

                          widget.reward.id,


                        );


                      }




                    },





                    child:

                    controller.loading.value



                        ?



                    const CircularProgressIndicator(



                      color:

                      Colors.white,


                    )




                        :



                    const Text(



                      "حفظ التعديل",



                      style:

                      TextStyle(



                        color:

                        Colors.white,


                        fontSize:16,


                      ),


                    ),




                  ),



                )

            )





          ],


        ),


      ),


    );

  }









  Widget _field(


      TextEditingController controller,


      String label,

      {


        int maxLines=1

      }


      ){



    return Padding(



      padding:

      const EdgeInsets.only(

          bottom:15

      ),





      child:

      TextField(



        controller:

        controller,



        maxLines:

        maxLines,




        decoration:



        InputDecoration(



          labelText:

          label,




          filled:

          true,




          fillColor:

          Colors.white,





          border:



          OutlineInputBorder(



            borderRadius:

            BorderRadius.circular(16),



          ),



        ),



      ),



    );

  }




}