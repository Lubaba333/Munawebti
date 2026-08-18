import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/ReportDetailsController.dart';
import 'package:supervisors/view/EditReportView.dart';


class ReportDetailsView extends StatelessWidget {


  ReportDetailsView({
    super.key,
  });


  final controller =
  Get.put(
      ReportDetailsController()
  );



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,



      appBar: AppBar(


        elevation: 0,


        centerTitle: true,


        backgroundColor:
        AppColors.primary,


        title: Text(

          "report_details".tr,

          style: TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize: 20,

          ),

        ),


      ),





      body: Obx((){


        if(controller.loading.value){


          return const Center(

            child:
            CircularProgressIndicator(),

          );

        }




        final report =
            controller.report.value;




        if(report == null){


          return  Center(

            child:

            Text(

              "no_data".tr,

              style:

              TextStyle(

                fontSize:16,

              ),

            ),

          );

        }




        return SingleChildScrollView(


          padding:

          const EdgeInsets.all(20),



          child: Column(


            children: [



              Container(


                width:
                double.infinity,


                padding:

                const EdgeInsets.all(20),



                decoration:

                BoxDecoration(


                  color:
                  AppColors.primary,


                  borderRadius:

                  BorderRadius.circular(25),


                ),



                child: Column(


                  children: [



                    const Icon(


                      Icons.description_outlined,


                      size:55,


                      color:
                      Colors.white,

                    ),




                    const SizedBox(

                      height:15,

                    ),



                    Text(


                      "student_report".tr,

                      style:

                      TextStyle(

                        color:
                        Colors.white,


                        fontSize:22,


                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                  ],

                ),



              ),





              const SizedBox(

                height:25,

              ),





              _infoCard(

                context: context,

                icon:
                Icons.notes,


                title:
                "notes".tr,


                value:
                report.notes,

              ),



            ],



          ),



        );



      }),



    );


  }





  Widget _infoCard({


    required BuildContext context,


    required IconData icon,


    required String title,


    required String value,


  }){


    return Container(


      width:

      double.infinity,



      padding:

      const EdgeInsets.all(18),




      decoration:


      BoxDecoration(



        color:
        Theme.of(context).cardColor,



        borderRadius:

        BorderRadius.circular(20),



        boxShadow: [


          BoxShadow(


            blurRadius:10,


            offset:

            const Offset(0,4),


            color:

            Colors.black.withOpacity(.08),


          )


        ],


      ),




      child: Column(


        crossAxisAlignment:

        CrossAxisAlignment.start,



        children: [



          Row(


            children: [



              Container(


                padding:

                const EdgeInsets.all(10),



                decoration:


                BoxDecoration(


                  color:

                  AppColors.primary.withOpacity(.15),


                  shape:

                  BoxShape.circle,


                ),



                child:

                Icon(


                  icon,


                  color:

                  AppColors.primary,


                ),



              ),





              const SizedBox(

                width:12,

              ),




              Text(


                title,


                style:


                const TextStyle(



                  fontSize:17,


                  fontWeight:

                  FontWeight.bold,



                ),


              ),




            ],



          ),





          const SizedBox(

            height:15,

          ),





          Text(


            value,


            style:


            TextStyle(


              fontSize:16,


              height:1.5,


              color:

              Theme.of(context).textTheme.bodyMedium?.color,


            ),



          ),




        ],


      ),



    );



  }



}