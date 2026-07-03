
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/view/EmergencyView.dart';
import 'package:supervisors/view/RequestsView.dart';
import 'package:supervisors/view/complaints_view.dart';

import '../controller/HomeController.dart';
import '../const/app_colors.dart';


class HomeView extends StatelessWidget {

  final controller = Get.put(HomeController());

  HomeView({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,


      body: SafeArea(

        child: Obx(() {


          if(controller.isLoading.value){

            return const Center(
              child: CircularProgressIndicator(),
            );

          }


          return SingleChildScrollView(

            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),


            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children: [


                /// HEADER

                Text(
                  "Welcome 👋",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),


                const SizedBox(height: 5),


                Text(
                  controller.userName,

                  style: const TextStyle(

                    fontSize: 28,

                    fontWeight:
                    FontWeight.bold,

                  ),
                ),



                const SizedBox(height:25),



                /// SHIFT CARD

                _shiftCard(context),

                const SizedBox(height:30),

                _title(
                    "Quick Actions"
                ),


                const SizedBox(height:15),



                /// ACTION GRID

                GridView.count(

                  shrinkWrap:true,

                  physics:
                  const NeverScrollableScrollPhysics(),


                  crossAxisCount:2,


                  crossAxisSpacing:15,

                  mainAxisSpacing:15,


                  children: [


                    _actionCard(

                      context: context,

                      icon:Icons.emergency,

                      title:"Emergency",

                      onTap:(){

                        Get.to(
                                ()=>EmergencyView()
                        );

                      },

                    ),



                    _actionCard(

                      context: context,

                      icon:Icons.report_problem,

                      title:"Complaints",

                      onTap:(){

                        Get.to(
                                ()=>ComplaintsView()
                        );

                      },

                    ),




                    _actionCard(

                      context: context,

                      icon:Icons.assignment,

                      title:"Requests",

                      onTap:(){

                        Get.to(
                                ()=>RequestsView()
                        );

                      },

                    ),




                    _actionCard(

                      context: context,

                      icon:Icons.check_circle,

                      title:"Attendance",

                    ),


                  ],

                ),




                const SizedBox(height:35),




                _title(
                    "Today's Schedule"
                ),



                const SizedBox(height:15),




                ...controller.todaySchedule
                    .map(
                        (e)=>
                        _scheduleCard(
                            e,
                            context
                        )
                ),



              ],

            ),

          );

        }),

      ),


    );

  }






  Widget _shiftCard(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;


    return Container(

      width: double.infinity,


      padding: EdgeInsets.symmetric(

        horizontal: screenWidth * 0.06,

        vertical: screenWidth * 0.055,

      ),


      decoration: BoxDecoration(


        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,


          colors: [

            AppColors.primary,

            AppColors.primary.withOpacity(0.75),

          ],

        ),



        borderRadius:
        BorderRadius.circular(28),



        boxShadow: [


          BoxShadow(

            color:
            AppColors.primary.withOpacity(0.25),

            blurRadius: 18,

            offset:
            const Offset(0,10),

          )


        ],


      ),



      child: Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


            children: [



              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [



                  Text(

                    "Current Shift",

                    style: TextStyle(

                      color:
                      Colors.white70,


                      fontSize:
                      screenWidth * .035,


                    ),

                  ),



                  const SizedBox(height:8),



                  Obx(()=>Text(


                    controller.currentShift['title']
                        ?? "No Shift",



                    style: TextStyle(


                      color:Colors.white,


                      fontSize:
                      screenWidth * .055,


                      fontWeight:
                      FontWeight.bold,


                    ),


                  )),


                ],

              ),




              Container(


                padding:
                const EdgeInsets.all(12),


                decoration: BoxDecoration(


                  color:
                  Colors.white.withOpacity(.18),


                  shape:
                  BoxShape.circle,


                ),


                child: const Icon(

                  Icons.access_time_rounded,

                  color:Colors.white,

                  size:30,

                ),


              )



            ],

          ),




          const SizedBox(height:22),




          Container(

            padding:
            const EdgeInsets.symmetric(

              horizontal:15,

              vertical:12,

            ),


            decoration: BoxDecoration(

              color:
              Colors.white.withOpacity(.15),


              borderRadius:
              BorderRadius.circular(18),

            ),



            child: Row(


              children: [



                const Icon(

                  Icons.schedule,

                  color:Colors.white70,

                  size:20,

                ),


                const SizedBox(width:10),




                Expanded(


                  child: Obx(()=>Text(


                    controller.currentShift['time']
                        ?? "No time available",



                    overflow:
                    TextOverflow.ellipsis,


                    style: TextStyle(

                      color:
                      Colors.white,


                      fontSize:
                      screenWidth * .035,


                      fontWeight:
                      FontWeight.w500,


                    ),


                  )),


                )



              ],


            ),


          ),




          const SizedBox(height:18),




          Row(

            children: [


              Container(

                width:10,

                height:10,

                decoration: const BoxDecoration(


                  color:Colors.greenAccent,

                  shape:BoxShape.circle,


                ),

              ),


              const SizedBox(width:8),



              const Text(

                "Active Now",

                style:TextStyle(

                  color:Colors.white70,

                  fontSize:14,

                ),

              )

            ],


          )



        ],

      ),


    );


  }






  Widget _actionCard({

    required BuildContext context,

    required IconData icon,

    required String title,

    VoidCallback? onTap,

  }){


    return InkWell(

      borderRadius:
      BorderRadius.circular(22),


      onTap:onTap,


      child:Container(

        decoration:BoxDecoration(

          color:Theme.of(context).cardColor,


          borderRadius:
          BorderRadius.circular(22),


          boxShadow:[

            const BoxShadow(

              color:Colors.black12,

              blurRadius:10,

              offset:
              Offset(0,5),

            )

          ],


        ),


        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Container(


              padding:
              const EdgeInsets.all(15),


              decoration:BoxDecoration(

                color:
                AppColors.primary.withOpacity(.15),


                shape:
                BoxShape.circle,

              ),


              child:Icon(

                icon,

                size:30,

                color:
                AppColors.primary,

              ),


            ),


            const SizedBox(height:12),



            Text(

              title,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.w600,

              ),

            )


          ],

        ),

      ),

    );

  }







  Widget _scheduleCard(

      Map<String,String> item,

      BuildContext context

      ){


    return Container(

      margin:
      const EdgeInsets.only(bottom:12),


      padding:
      const EdgeInsets.all(18),


      decoration:BoxDecoration(

        color:
        Theme.of(context).cardColor,


        borderRadius:
        BorderRadius.circular(18),


      ),


      child:Row(

        children:[


          Icon(

            Icons.access_time,

            color:
            AppColors.primary,

          ),



          const SizedBox(width:15),



          Text(
            item['time'] ?? "",
          ),



          const Spacer(),



          Text(
            item['place'] ?? "",
          ),



        ],

      ),


    );


  }





  Widget _title(String text){


    return Text(

      text,


      style:const TextStyle(

        fontSize:20,

        fontWeight:
        FontWeight.bold,

      ),

    );


  }



}