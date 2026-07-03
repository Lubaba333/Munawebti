import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ViolationsController.dart';
import 'package:supervisors/models/ViolationModel.dart';
import 'package:supervisors/view/StudentsView.dart';
import 'package:supervisors/view/ViolationDetailsView.dart';


class EditViolationView extends StatefulWidget {


  final ViolationModel violation;



  const EditViolationView({

    super.key,

    required this.violation,

  });


  @override
  State<EditViolationView> createState()
  => _EditViolationViewState();

}




class _EditViolationViewState
    extends State<EditViolationView>{



  final controller =
  Get.find<ViolationsController>();



  late TextEditingController title;
  late TextEditingController description;
  late TextEditingController date;
  late TextEditingController category;
  late TextEditingController penalty;




  @override
  void initState(){


    super.initState();


    title =
        TextEditingController(
            text: widget.violation.title
        );


    description =
        TextEditingController(
            text: widget.violation.description
        );


    date =
        TextEditingController(
            text: widget.violation.violationDate
        );



    category =
        TextEditingController(
            text: widget.violation.category
        );



    penalty =
        TextEditingController(
            text: widget.violation.penalty
        );



  }



  @override
  void dispose(){

    title.dispose();
    description.dispose();
    date.dispose();
    category.dispose();
    penalty.dispose();

    super.dispose();

  }




  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,


      appBar: AppBar(

        title:
        const Text(
            "تعديل المخالفة"
        ),

        backgroundColor:
        AppColors.primary,


      ),



      body:


      SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child:Column(

          children:[


            _field(
                title,
                "العنوان"
            ),


            _field(
                description,
                "الوصف",
                max:3
            ),


            _field(
                date,
                "التاريخ"
            ),


            _field(
                category,
                "التصنيف"
            ),


            _field(
                penalty,
                "العقوبة"
            ),


            const SizedBox(height:30),



            Obx(()=>SizedBox(

              width:
              double.infinity,


              child:ElevatedButton(


                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primary,

                  padding:
                  const EdgeInsets.all(16),

                ),



                onPressed:
                controller.loading.value

                    ?null

                    :

                    ()async{


                  bool success =

                  await controller.updateViolation(

                    violationId:
                    widget.violation.id,


                    title:
                    title.text,


                    description:
                    description.text,


                    violationDate:
                    date.text,


                    category:
                    category.text,


                    penalty:
                    penalty.text,

                  );



                  if(success){

                    Get.off(
                          ()=>ViolationDetailsView(),
                      arguments: widget.violation.id,
                    );

                  }



                },



                child:

                controller.loading.value

                    ?

                const CircularProgressIndicator(
                    color:Colors.white
                )

                    :

                const Text(
                  "حفظ التعديل",
                  style:
                  TextStyle(
                      color:Colors.white
                  ),
                ),


              ),



            ))


          ],


        ),


      ),


    );


  }




  Widget _field(
      TextEditingController c,
      String label,
      {int max=1}

      ){

    return Padding(

      padding:
      const EdgeInsets.only(
          bottom:15
      ),


      child:TextField(

        controller:c,

        maxLines:max,


        decoration:
        InputDecoration(

            labelText:
            label,


            filled:true,

            fillColor:
            Theme.of(context).cardColor,


            border:
            OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(16)

            )

        ),


      ),


    );

  }



}