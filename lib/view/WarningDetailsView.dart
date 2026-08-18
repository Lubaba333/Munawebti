import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/WarningDetailsController.dart';

import 'EditWarningView.dart';



class WarningDetailsView extends StatefulWidget {

  const WarningDetailsView({
    super.key,
  });


  @override
  State<WarningDetailsView> createState() =>
      _WarningDetailsViewState();

}



class _WarningDetailsViewState
    extends State<WarningDetailsView>
    with SingleTickerProviderStateMixin {



  final controller =
  Get.put(
    WarningDetailsController(),
  );



  late AnimationController animationController;

  late Animation<double> fade;



  @override
  void initState() {

    super.initState();


    animationController =
        AnimationController(

          vsync:this,

          duration:
          const Duration(
              milliseconds:600
          ),

        );


    fade =
        CurvedAnimation(

          parent:
          animationController,

          curve:
          Curves.easeOut,

        );


    animationController.forward();

  }



  @override
  void dispose() {

    animationController.dispose();

    super.dispose();

  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,



      appBar: AppBar(


        elevation:0,


        centerTitle:true,


        backgroundColor:
        AppColors.primary,



        title:

        Text(

          "warning_details".tr,

          style:

          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),


      ),




      body:


      Obx(() {



        if(controller.loading.value){


          return const Center(

            child:
            CircularProgressIndicator(),

          );

        }



        final warning =
            controller.warning.value;



        if(warning == null){


          return Center(

            child:
            Text(
              "no_data".tr,
            ),

          );

        }





        return FadeTransition(


          opacity:
          fade,



          child:

          SingleChildScrollView(



            padding:
            const EdgeInsets.all(20),



            child:

            Column(



              children:[





                _headerCard(

                    warning.title

                ),




                const SizedBox(
                  height:20,
                ),






                _infoCard(


                  context: context,


                  icon:
                  Icons.description_outlined,


                  title:
                  "description".tr,


                  value:
                  warning.description,


                ),







                _infoCard(


                  context: context,


                  icon:
                  Icons.calendar_month,


                  title:
                  "warning_date".tr,


                  value:
                  warning.warningDate.split('T')
                      .first,


                ),







                _infoCard(


                  context: context,


                  icon:
                  Icons.gavel_outlined,


                  title:
                  "possible_penalty".tr,


                  value:
                  warning.possiblePenalty,


                ),





                //
                // const SizedBox(
                //   height:30,
                // ),
                //
                //

              ],



            ),



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
      const EdgeInsets.all(22),



      decoration:


      BoxDecoration(



        color:

        AppColors.primary,



        borderRadius:

        BorderRadius.circular(25),



        boxShadow:[



          BoxShadow(


            color:
            Colors.black.withOpacity(.08),


            blurRadius:15,


            offset:
            const Offset(0,8),

          )



        ],


      ),





      child:

      Column(



        children:[





          Container(


            width:80,

            height:80,



            decoration:


            BoxDecoration(


              color:
              Colors.white.withOpacity(.2),


              shape:
              BoxShape.circle,


            ),



            child:


            const Icon(


              Icons.warning_amber_rounded,


              size:45,


              color:
              Colors.white,


            ),



          ),





          const SizedBox(
            height:15,
          ),





          Text(



            title,



            textAlign:
            TextAlign.center,



            style:

            const TextStyle(



              color:
              Colors.white,



              fontSize:21,



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

          bottom:15

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
            Colors.black.withOpacity(.06),


            blurRadius:12,


            offset:
            const Offset(0,5),


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




          children:[





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





            const SizedBox(
              width:15,
            ),






            Expanded(



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



                      fontSize:16,



                    ),



                  ),




                  const SizedBox(
                    height:8,
                  ),





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