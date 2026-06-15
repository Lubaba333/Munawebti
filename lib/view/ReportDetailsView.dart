import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ReportDetailsController.dart';
import 'package:supervisors/view/EditReportView.dart';





class ReportDetailsView extends StatelessWidget {


  ReportDetailsView({
    super.key
  });


  final controller =
  Get.put(
      ReportDetailsController()
  );



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      AppColors.background,


      appBar:

      AppBar(

        title:
        const Text(
            "تفاصيل التقرير"
        ),

        backgroundColor:
        AppColors.primary,

      ),



      body:


      Obx((){


        if(controller.loading.value){

          return const Center(
              child:
              CircularProgressIndicator()
          );

        }



        final report =
            controller.report.value;



        if(report == null){

          return const Center(
              child:
              Text(
                  "لا يوجد بيانات"
              )
          );

        }



        return ListView(

          padding:
          const EdgeInsets.all(20),


          children:[



            // _card(
            //     "نوع التقرير",
            //     report.reportType
            // ),
            //
            //
            //
            // _card(
            //     "الوصف",
            //     report.description
            // ),



            _card(
                "الملاحظات",
                report.notes
            ),

            const SizedBox(
                height:25
            ),



            ElevatedButton.icon(


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

                  ),

                ),



                icon:
                const Icon(
                    Icons.edit
                ),



                label:
                const Text(
                    "تعديل التقرير"
                ),



                onPressed:(){


                  Get.to(

                        ()=>EditReportView(
                          report: report,

                    ),

                  );


                }

            )



          ],



        );


      }),


    );


  }




  Widget _card(
      String title,
      String value
      ){

    return Card(

      elevation:4,


      margin:
      const EdgeInsets.only(
          bottom:15
      ),



      child:

      Padding(

        padding:
        const EdgeInsets.all(18),


        child:

        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            Text(

              title,

              style:
              const TextStyle(

                  fontWeight:
                  FontWeight.bold,

                  fontSize:16

              ),

            ),



            const SizedBox(
                height:8
            ),



            Text(
                value
            )


          ],

        ),

      ),


    );


  }



}