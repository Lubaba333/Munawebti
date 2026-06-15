import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/controller/RewardsController.dart';
import 'package:supervisors/models/RewardModel.dart';
import 'package:supervisors/view/RewardDetailsView.dart';




class EditRewardView extends StatefulWidget{


  final RewardModel reward;


  const EditRewardView({

    super.key,

    required this.reward

  });


  @override
  State<EditRewardView> createState()
  =>_EditRewardViewState();


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





    title=
        TextEditingController(
            text:widget.reward.title
        );


    description=
        TextEditingController(
            text:widget.reward.description
        );


    date=
        TextEditingController(
            text:widget.reward.createdAt
        );





  }



  @override
  Widget build(BuildContext context){


    return Scaffold(


        appBar:
        AppBar(

          title:
          const Text(
              "تعديل المكافأة"
          ),

        ),


        body:Padding(

          padding:
          const EdgeInsets.all(20),


          child:Column(

              children:[






                _field(title,"العنوان"),


                _field(description,"الوصف"),


                _field(date,"التاريخ"),






                const SizedBox(height:25),



                Obx(()=>ElevatedButton(


                  onPressed:

                  controller.loading.value

                      ?null

                      :

                      ()async{


                    bool success =
                    await controller.updateReward(


                      rewardId:
                      widget.reward.id,



                      title:
                      title.text,


                      description:
                      description.text,


                      rewardDate:
                      date.text,


                    );



                    if(success){

                      Get.off(
                              ()=>RewardDetailsView(),
                        arguments: widget.reward.id,
                      );

                    }



                  },


                  child:
                  controller.loading.value

                      ?
                  const CircularProgressIndicator()

                      :
                  const Text(
                      "حفظ"
                  ),


                ))




              ]

          ),


        )

    );

  }



  Widget _field(
      TextEditingController c,
      String label

      ){

    return Padding(

      padding:
      const EdgeInsets.only(
          bottom:12
      ),

      child:TextField(

        controller:c,


        decoration:
        InputDecoration(

            labelText:label,

            border:
            const OutlineInputBorder()

        ),

      ),

    );

  }



}