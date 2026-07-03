import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/ReportsController.dart';
import '../models/ReportModel.dart';
import 'ReportDetailsView.dart';



class EditReportView extends StatefulWidget {


  final ReportModel report;


  const EditReportView({

    super.key,

    required this.report,

  });



  @override
  State<EditReportView> createState()
  =>
      _EditReportViewState();



}



class _EditReportViewState
    extends State<EditReportView> {


  final controller =
  Get.find<ReportsController>();




  late TextEditingController notes;



  @override
  void initState() {

    super.initState();




    notes =
        TextEditingController(
          text:
          widget.report.notes,
        );


  }





  @override
  void dispose() {



    notes.dispose();

    super.dispose();

  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,



      appBar:

      AppBar(

        title:
        const Text(
            "تعديل التقرير"
        ),

        backgroundColor:
        AppColors.primary,

        centerTitle:true,

      ),




      body:


      Padding(


        padding:
        const EdgeInsets.all(20),



        child:

        SingleChildScrollView(


          child:

          Column(


            children: [



              const SizedBox(
                  height:15
              ),




              _field(

                controller:
                notes,

                label:
                "الملاحظات",

                maxLines:
                4,

              ),



              const SizedBox(
                  height:15
              ),





              const SizedBox(
                  height:30
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

                        ?

                    null


                        :

                        () async {



                      bool success =

                      await controller.updateReport(

                        reportId:
                        widget.report.id,

                        notes:
                        notes.text.trim(),

                      );




                      if(success){

                        Get.off(
                              ()=>ReportDetailsView(),
                          arguments: widget.report.id,
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

                      ),

                    ),



                  ),



                ),

              )




            ],


          ),


        ),


      ),


    );


  }







  Widget _field({


    required TextEditingController controller,


    required String label,


    int maxLines = 1,


  }){


    return TextField(


      controller:
      controller,


      maxLines:
      maxLines,



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

          BorderRadius.circular(16),


        ),


      ),


    );


  }



}