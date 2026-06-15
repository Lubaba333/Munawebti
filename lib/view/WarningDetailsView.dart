import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/WarningDetailsController.dart';
import 'package:supervisors/view/EditWarningView.dart';


class WarningDetailsView extends StatelessWidget {

  WarningDetailsView({super.key});


  final controller =
  Get.put(
    WarningDetailsController(),
  );


  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xffF5F7FB),



      appBar: AppBar(


        elevation:0,


        backgroundColor:
        AppColors.primary,


        centerTitle:true,


        title:

        const Text(

          "تفاصيل التحذير",

          style:TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),


      ),




      body:

      Obx((){


        if(controller.loading.value){


          return const Center(

            child:
            CircularProgressIndicator(),

          );

        }



        final warning =
            controller.warning.value;




        if(warning == null){


          return const Center(

            child:
            Text(

              "لا توجد بيانات",

              style:TextStyle(

                fontSize:18,

              ),

            ),

          );

        }




        return SingleChildScrollView(


          padding:
          const EdgeInsets.all(20),



          child:Column(


            children:[




              Container(


                width:
                double.infinity,


                padding:
                const EdgeInsets.all(20),



                decoration:

                BoxDecoration(


                  color:
                  Colors.white,


                  borderRadius:
                  BorderRadius.circular(25),


                  boxShadow:[


                    BoxShadow(


                      color:
                      Colors.black12,


                      blurRadius:10,


                      offset:
                      const Offset(0,5),


                    )


                  ],


                ),



                child:Column(


                  children:[



                    CircleAvatar(


                      radius:35,


                      backgroundColor:
                      AppColors.primary,


                      child:

                      const Icon(

                        Icons.warning_amber_rounded,


                        size:40,


                        color:Colors.white,

                      ),


                    ),



                    const SizedBox(
                      height:20,
                    ),



                    Text(


                      warning.title,


                      textAlign:
                      TextAlign.center,


                      style:

                      const TextStyle(


                        fontSize:22,


                        fontWeight:
                        FontWeight.bold,


                      ),


                    ),




                  ],

                ),



              ),





              const SizedBox(
                height:20,
              ),





              _infoTile(

                icon:
                Icons.description,


                title:
                "الوصف",


                value:
                warning.description,

              ),





              _infoTile(

                icon:
                Icons.calendar_month,


                title:
                "تاريخ التحذير",


                value:
                warning.warningDate,

              ),





              _infoTile(

                icon:
                Icons.gavel,


                title:
                "العقوبة المحتملة",


                value:
                warning.possiblePenalty,

              ),





              const SizedBox(
                height:30,
              ),





              SizedBox(


                width:
                double.infinity,



                child:

                ElevatedButton.icon(


                  icon:

                  const Icon(
                    Icons.edit,
                  ),



                  label:

                  const Text(

                    "تعديل التحذير",

                    style:

                    TextStyle(

                      fontSize:17,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  style:

                  ElevatedButton.styleFrom(


                    backgroundColor:
                    AppColors.primary,


                    padding:

                    const EdgeInsets.symmetric(

                      vertical:15,

                    ),



                    shape:

                    RoundedRectangleBorder(


                      borderRadius:
                      BorderRadius.circular(18),


                    ),



                  ),





                  onPressed:(){



                    Get.to(


                          ()=>EditWarningView(


                        warning:
                        warning,


                      ),


                    );


                  },


                ),


              )



            ],

          ),



        );



      }),



    );

  }






  Widget _infoTile({

    required IconData icon,

    required String title,

    required String value,

  }){


    return Container(


      margin:
      const EdgeInsets.only(
        bottom:15,
      ),


      padding:
      const EdgeInsets.all(18),


      decoration:

      BoxDecoration(


        color:
        Colors.white,


        borderRadius:
        BorderRadius.circular(18),


        boxShadow:[


          BoxShadow(

            color:
            Colors.black12,

            blurRadius:6,

          )


        ],


      ),



      child:Row(


        crossAxisAlignment:
        CrossAxisAlignment.start,



        children:[



          Container(


            padding:
            const EdgeInsets.all(10),


            decoration:

            BoxDecoration(


              color:
              AppColors.primary.withOpacity(.15),


              borderRadius:
              BorderRadius.circular(12),


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

            child:Column(


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

                  const TextStyle(

                    fontSize:15,

                    color:
                    Colors.black87,

                  ),

                ),


              ],


            ),

          )



        ],


      ),


    );

  }


}