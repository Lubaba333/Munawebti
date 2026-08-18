import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supervisors/view/EditViolationView.dart';

import '../const/app_colors.dart';
import '../controller/ViolationDetailsController.dart';



class ViolationDetailsView
    extends StatelessWidget {


  ViolationDetailsView({
    super.key,
  });



  final controller =
  Get.put(
    ViolationDetailsController(),
  );




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,



      appBar: AppBar(


        elevation: 0,


        centerTitle: true,


        title:

        Text(

          "violation_details".tr,

          style:

          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        backgroundColor:

        AppColors.primary,


      ),





      body:

      Obx(() {



        if(controller.loading.value){


          return const Center(

            child:

            CircularProgressIndicator(),

          );

        }



        final violation =

            controller.violation.value;



        if(violation == null){


          return Center(

            child:

            Text(
              "no_data".tr,
            ),

          );

        }





        return SingleChildScrollView(


          padding:

          const EdgeInsets.all(20),



          child:

          Column(

            children: [



              _headerCard(violation.title),




              const SizedBox(height:20),




              _infoCard(

                context: context,

                icon:
                Icons.description_outlined,

                title:
                "description".tr,

                value:
                violation.description,

              ),




              _infoCard(

                context: context,

                icon:
                Icons.category_outlined,

                title:
                "category".tr,

                value:
                violation.category,

              ),





              _infoCard(

                context: context,

                icon:
                Icons.warning_amber_outlined,

                title:
                "penalty".tr,

                value:
                violation.penalty,

              ),






              _infoCard(

                context: context,

                icon:
                Icons.date_range,

                title:
                "violation_date".tr,

                value:
                violation.violationDate.split('T')
                    .first,

              ),


            ],

          ),


        );

      }),


    );

  }








  Widget _headerCard(String title){


    return Container(


      width:
      double.infinity,



      padding:

      const EdgeInsets.all(20),



      decoration:

      BoxDecoration(


        color:

        AppColors.primary,



        borderRadius:

        BorderRadius.circular(22),


      ),




      child:

      Column(


        children: [



          const Icon(

            Icons.report_problem,

            size:50,

            color:Colors.white,

          ),




          const SizedBox(height:10),





          Text(


            title,



            textAlign:
            TextAlign.center,



            style:

            const TextStyle(


              color:

              Colors.white,



              fontSize:20,


              fontWeight:

              FontWeight.bold,


            ),



          )



        ],

      ),


    );


  }







  Widget _infoCard({

    required BuildContext context,

    required IconData icon,

    required String title,

    required String value,

  }){


    return Container(


      margin:

      const EdgeInsets.only(

        bottom:15,

      ),




      decoration:

      BoxDecoration(


        color:

        Theme.of(context).cardColor,



        borderRadius:

        BorderRadius.circular(20),



        boxShadow:[


          BoxShadow(

            color:

            Colors.black12,

            blurRadius:8,

            offset:

            const Offset(0,3),

          )


        ],


      ),




      child:

      Padding(

        padding:

        const EdgeInsets.all(18),




        child:

        Row(


          crossAxisAlignment:

          CrossAxisAlignment.start,



          children: [



            Container(


              padding:

              const EdgeInsets.all(12),



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




            const SizedBox(width:15),





            Expanded(


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




                  const SizedBox(height:8),




                  Text(


                    value,



                    style:

                    TextStyle(

                      fontSize:15,

                      color:

                      Theme.of(context).textTheme.bodyMedium?.color,

                    ),


                  )



                ],


              ),


            )




          ],


        ),



      ),


    );


  }



}