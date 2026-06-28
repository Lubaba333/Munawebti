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
      AppColors.background,



      appBar: AppBar(


        elevation: 0,


        centerTitle: true,


        backgroundColor:
        AppColors.primary,


        title: const Text(

          "تفاصيل التقرير",

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


          return const Center(

            child:

            Text(

              "لا يوجد بيانات",

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



                    const Text(


                      "تقرير الطالب",

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

                icon:
                Icons.notes,


                title:
                "الملاحظات",


                value:
                report.notes,

              ),





              const SizedBox(

                height:30,

              ),





              SizedBox(


                width:

                double.infinity,



                child:


                ElevatedButton.icon(



                  onPressed:(){



                    Get.to(


                          ()=>EditReportView(

                        report: report,


                      ),


                    );



                  },



                  icon:


                  const Icon(

                      Icons.edit

                  ),



                  label:


                  const Text(


                    "تعديل التقرير",


                    style:


                    TextStyle(

                      fontSize:16,

                      fontWeight:

                      FontWeight.bold,

                    ),


                  ),





                  style:


                  ElevatedButton.styleFrom(


                    backgroundColor:

                    AppColors.primary,



                    foregroundColor:

                    Colors.white,



                    padding:

                    const EdgeInsets.symmetric(

                      vertical:16,

                    ),



                    shape:


                    RoundedRectangleBorder(


                      borderRadius:

                      BorderRadius.circular(18),


                    ),



                  ),


                ),



              )



            ],



          ),



        );



      }),



    );


  }





  Widget _infoCard({


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
        Colors.white,



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


            const TextStyle(


              fontSize:16,


              height:1.5,


              color:

              Colors.black87,


            ),



          ),




        ],


      ),



    );



  }



}