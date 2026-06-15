import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/warning_controller.dart';
import 'package:supervisors/models/WarningModel.dart';
import 'package:supervisors/view/StudentsView.dart';





class EditWarningView extends StatefulWidget {


  final WarningModel warning;


  const EditWarningView({

    super.key,

    required this.warning,

  });



  @override
  State<EditWarningView> createState()
  => _EditWarningViewState();



}




class _EditWarningViewState
    extends State<EditWarningView>{



  final controller =
  Get.find<WarningsController>();



  late TextEditingController title;

  late TextEditingController description;

  late TextEditingController date;

  late TextEditingController penalty;



  @override
  void initState(){


    super.initState();



    title =
        TextEditingController(
            text: widget.warning.title
        );



    description =
        TextEditingController(
            text: widget.warning.description
        );



    date =
        TextEditingController(
            text: widget.warning.warningDate.split('T').first
        );



    penalty =
        TextEditingController(
            text: widget.warning.possiblePenalty
        );



  }



  @override
  void dispose(){

    title.dispose();
    description.dispose();
    date.dispose();
    penalty.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context){



    return Scaffold(


      backgroundColor:
      Colors.grey[100],



      appBar: AppBar(


        automaticallyImplyLeading:false,


        title:
        const Text(
            "تعديل التحذير"
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
              "العنوان",
            ),


            _field(
              description,
              "الوصف",
              maxLines:4,
            ),



            _field(
              date,
              "تاريخ التحذير",
            ),



            _field(
              penalty,
              "العقوبة المحتملة",
            ),




            const SizedBox(height:30),




            Obx(()=>SizedBox(


              width:double.infinity,


              child:ElevatedButton(



                style:
                ElevatedButton.styleFrom(


                    backgroundColor:
                    AppColors.primary,


                    padding:
                    const EdgeInsets.all(15),


                    shape:
                    RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(15)

                    )

                ),




                onPressed:

                controller.loading.value

                    ?

                null


                    :

                    ()async{



                  bool success =

                  await controller.updateWarning(


                    warningId:
                    widget.warning.id,


                    title:
                    title.text,


                    description:
                    description.text,


                    warningDate:
                    date.text,


                    possiblePenalty:
                    penalty.text,



                  );



                  if(success){


                    Get.offAll(
                            ()=>StudentsView()
                    );


                  }




                },

                child:


                controller.loading.value


                    ?


                const CircularProgressIndicator(
                  color: Colors.white,
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


            ),




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
      const EdgeInsets.only(bottom:15),


      child:TextField(


        controller:
        controller,


        maxLines:maxLines,


        decoration:

        InputDecoration(


            labelText:
            label,


            filled:true,


            fillColor:
            Colors.white,


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