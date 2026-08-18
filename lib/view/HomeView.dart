
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/view/EmergencyView.dart';
import 'package:supervisors/view/RequestsView.dart';
import 'package:supervisors/view/complaints_view.dart';
import 'package:supervisors/view/upcoming_shift_view.dart';
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
                  "welcome".tr,
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
                    "quick_actions".tr
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

                      title:"emergency".tr,

                      onTap:(){

                        Get.to(
                                ()=>EmergencyView()
                        );

                      },

                    ),



                    _actionCard(

                      context: context,

                      icon:Icons.report_problem,

                      title:"complaints".tr,

                      onTap:(){

                        Get.to(
                                ()=>ComplaintsView()
                        );

                      },

                    ),




                    _actionCard(

                      context: context,

                      icon:Icons.assignment,

                      title:"requests".tr,

                      onTap:(){

                        Get.to(
                                ()=>RequestsView()
                        );

                      },

                    ),




                    // _actionCard(
                    //
                    //   context: context,
                    //
                    //   icon:Icons.check_circle,
                    //
                    //   title:"attendance".tr,
                    //
                    //   onTap:(){
                    //
                    //     Get.to(
                    //             ()=>UpcomingShiftView()
                    //     );
                    //
                    //   },
                    //
                    // ),



                    _actionCard(
                      context: context,
                      icon: Icons.check_circle,
                      title: "attendance".tr,
                      onTap: () {

                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration:  BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  "choose_attendance_type".tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),


                                ListTile(
                                  leading: const Icon(
                                    Icons.menu_book,
                                  ),
                                  title: Text(
                                    "lecture_attendance".tr,
                                  ),
                                  onTap: () {

                                    Get.back();

                                    Get.to(
                                          () => UpcomingShiftView(
                                        shiftType: "lecture",
                                      ),
                                    );

                                  },
                                ),


                                ListTile(
                                  leading: const Icon(
                                    Icons.home_work,
                                  ),
                                  title: Text(
                                    "housing_attendance".tr,
                                  ),
                                  onTap: () {

                                    Get.back();

                                    Get.to(
                                          () => UpcomingShiftView(
                                        shiftType: "housing",
                                      ),
                                    );

                                  },
                                ),

                              ],
                            ),
                          ),
                        );

                      },
                    ),


                  ],

                ),




                const SizedBox(height:35),




                _title(
                    "todays_schedule".tr
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

                    "current_shift".tr,

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
                        ??"no_shift".tr,



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
                        ?? "no_time_available".tr,



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



               Text(

                "active_now".tr,

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
      Map<String, String> item,
      BuildContext context,
      ) {

    final bool isLecture = item["type"] == "lecture";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLecture
            ? AppColors.primary.withOpacity(.12)
            : Colors.blue.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLecture
              ? AppColors.primary
              : Colors.blue,
          width: 1.5,
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLecture
                  ? Color(0xFFA467A7)
                  : Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLecture
                  ? Icons.school
                  : Icons.apartment,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// اسم المادة أو اسم مبنى السكن
                Text(
                  item["place"] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// تفاصيل المحاضرة
                if (isLecture) ...[

                  if ((item["teacher"] ?? "").isNotEmpty)
                    Text(
                      "👨‍🏫 ${item["teacher"]}",
                      style: const TextStyle(fontSize: 13),
                    ),

                  if ((item["lab"] ?? "").isNotEmpty)
                    Text(
                      "🏫 ${item["lab"]}",
                      style: const TextStyle(fontSize: 13),
                    ),

                  if ((item["specialization"] ?? "").isNotEmpty)
                    Text(
                      "🎓 ${item["specialization"]}",
                      style: const TextStyle(fontSize: 13),
                    ),

                  if ((item["year"] ?? "").isNotEmpty)
                    Text(
                      "📚 ${"year".tr} ${item["year"]}",
                      style: const TextStyle(fontSize: 13),
                    ),

                  const SizedBox(height: 6),
                ],

                /// الوقت
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item["time"] ?? "",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isLecture
                  ? Color(0xFFA467A7)
                  : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isLecture ? "lecture".tr : "housing".tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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