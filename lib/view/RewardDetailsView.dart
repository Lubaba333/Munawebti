import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:supervisors/const/app_colors.dart';
import 'package:supervisors/controller/RewardDetailsController.dart';
import 'package:supervisors/view/EditRewardView.dart';



class RewardDetailsView extends StatelessWidget {


  RewardDetailsView({
    super.key,
  });



  final controller =
  Get.put(
    RewardDetailsController(),
  );




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar: AppBar(


        elevation:0,


        centerTitle:true,


        backgroundColor:
        AppColors.primary,


        title:

        const Text(

          "تفاصيل المكافأة",

          style:

          TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize:20,

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





        final reward =
            controller.reward.value;





        if(reward == null){


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


                      Icons.emoji_events_outlined,


                      size:60,


                      color:

                      Colors.white,


                    ),




                    const SizedBox(

                      height:15,

                    ),




                    Text(



                      reward.title,



                      textAlign:

                      TextAlign.center,



                      style:


                      const TextStyle(


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

                Icons.title,


                title:

                "العنوان",


                value:

                reward.title,


              ),






              _infoCard(


                icon:

                Icons.description_outlined,


                title:

                "الوصف",


                value:

                reward.description,


              ),







              _infoCard(


                icon:

                Icons.calendar_month,


                title:

                "تاريخ الإنشاء",


                value:


                reward.createdAt
                    .split('T')
                    .first,


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


                          ()=>EditRewardView(


                        reward:

                        reward,


                      ),



                    );



                  },





                  icon:


                  const Icon(

                    Icons.edit,

                  ),





                  label:


                  const Text(



                    "تعديل المكافأة",



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

        BorderRadius.circular(20),




        boxShadow:[


          BoxShadow(


            blurRadius:10,


            offset:

            const Offset(0,4),


            color:

            Colors.black.withOpacity(.08),


          )


        ],



      ),





      child:

      Column(



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

                  AppColors.primary
                      .withOpacity(.15),



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



          )





        ],


      ),



    );



  }



}