import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/attendance_history_controller.dart';
import '../models/attendance_history_model.dart';
import '../services/api_service.dart';



class AttendanceHistoryView
    extends GetView<AttendanceHistoryController> {


  AttendanceHistoryView({super.key});


  final AttendanceHistoryController controller =
  Get.put(
    AttendanceHistoryController(
      ApiService(),
    ),
  );




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xffF6F8FC),


      body: SafeArea(

        child: CustomScrollView(

          slivers:[



            SliverToBoxAdapter(

              child:_buildHeader(),

            ),


            SliverToBoxAdapter(

              child:
              _buildFilters(),

            ),





            SliverToBoxAdapter(

              child:
              const SizedBox(height:10),

            ),





            Obx((){


              if(controller.isLoading.value &&
                  controller.history.isEmpty){


                return const SliverFillRemaining(

                  child:
                  Center(

                    child:
                    CircularProgressIndicator(),

                  ),

                );

              }






              if(controller.history.isEmpty){


                return const SliverFillRemaining(

                  child:
                  Center(

                    child:
                    Text(

                      "No attendance records",

                      style:
                      TextStyle(

                        color:
                        Colors.grey,

                      ),

                    ),

                  ),

                );


              }






              return SliverPadding(

                padding:
                const EdgeInsets.symmetric(
                    horizontal:16
                ),



                sliver:
                SliverList(

                  delegate:
                  SliverChildBuilderDelegate(

                        (context,index){


                          if(index == controller.history.length){

                            if(controller.hasMore.value){

                              controller.loadNextPage();

                              return const Padding(

                                padding: EdgeInsets.all(20),

                                child:
                                Center(
                                  child:
                                  CircularProgressIndicator(),
                                ),

                              );

                            }


                            return const SizedBox();

                          }



                          final item =
                          controller.history[index];


                          return _attendanceCard(item);

                    },



                    childCount:
                    controller.history.length + 1,

                  ),

                ),

              );



            })




          ],

        ),

      ),


    );

  }









// ================= HEADER ===================


  Widget _buildHeader(){


    return Container(


      padding:
      const EdgeInsets.fromLTRB(
          20,
          30,
          20,
          35
      ),



      decoration:
      const BoxDecoration(


        gradient:
        LinearGradient(

          colors:
          AppColors.mainGradient,

          begin:
          Alignment.topLeft,

          end:
          Alignment.bottomRight,

        ),


        borderRadius:
        BorderRadius.vertical(

          bottom:
          Radius.circular(35),

        ),


      ),




      child:Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[




          Row(

            children:[



              Container(

                padding:
                const EdgeInsets.all(14),


                decoration:
                BoxDecoration(

                  color:
                  Colors.white.withOpacity(.20),

                  borderRadius:
                  BorderRadius.circular(18),

                ),



                child:
                const Icon(

                  Icons.fact_check_rounded,

                  color:
                  Colors.white,

                  size:32,

                ),

              ),



              const SizedBox(width:15),




              const Expanded(

                child:
                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,


                  children:[



                    Text(

                      "Attendance",

                      style:
                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:24,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    SizedBox(height:5),




                    Text(

                      "Student attendance history",

                      style:
                      TextStyle(

                        color:
                        Colors.white70,

                        fontSize:14,

                      ),

                    ),



                  ],

                ),

              ),





            ],

          ),





          const SizedBox(height:25),




          Obx(()=>Text(

            "${controller.history.length} attendance records",

            style:
            const TextStyle(

              color:
              Colors.white,

              fontSize:16,

              fontWeight:
              FontWeight.w600,

            ),

          )),


        ],


      ),


    );


  }



  // ================= FILTERS ===================


  Widget _buildFilters(){


    return Padding(

      padding:
      const EdgeInsets.symmetric(
        horizontal:16,
      ),

      child:
      Column(

        children:[


          Container(

            padding:
            const EdgeInsets.all(6),


            decoration:
            BoxDecoration(

                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(20),


                boxShadow:[

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(.05),

                    blurRadius:10,

                    offset:
                    const Offset(0,4),

                  )

                ]


            ),



            child:
            Obx(()=>Row(

              children:[


                Expanded(

                  child:
                  _filterChip(

                    title:"Lecture",

                    icon:
                    Icons.school_rounded,

                    value:"lecture",

                  ),

                ),



                Expanded(

                  child:
                  _filterChip(

                    title:"Housing",

                    icon:
                    Icons.home_work_rounded,

                    value:"housing",

                  ),

                ),



              ],


            )),


          ),





          const SizedBox(height:15),





        ],

      ),

    );


  }








  Widget _filterChip({

    required String title,

    required IconData icon,

    required String value,

  }){


    final selected =
        controller.selectedType.value == value;



    return GestureDetector(


      onTap:(){

        controller.changeType(value);

      },


      child:
      AnimatedContainer(

        duration:
        const Duration(
          milliseconds:250,
        ),



        padding:
        const EdgeInsets.symmetric(
          vertical:12,
        ),



        margin:
        const EdgeInsets.all(3),




        decoration:
        BoxDecoration(


          gradient:
          selected

              ?

          const LinearGradient(

            colors:
            AppColors.mainGradient,

          )

              :

          null,



          borderRadius:
          BorderRadius.circular(16),


        ),




        child:
        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(

              icon,

              size:20,

              color:

              selected

                  ?
              Colors.white

                  :
              AppColors.primary,


            ),



            const SizedBox(width:8),




            Text(

              title,

              style:
              TextStyle(

                fontWeight:
                FontWeight.bold,


                color:

                selected

                    ?
                Colors.white

                    :
                Colors.black,


              ),

            ),



          ],


        ),


      ),


    );


  }











// ================= ATTENDANCE CARD ===================



  Widget _attendanceCard(
      AttendanceHistoryModel item
      ){



    final isLecture =
        item.shiftType == "lecture";




    return GestureDetector(


      onTap:(){

        _showStudentDetails(item);

      },


      child:
      Container(


        margin:
        const EdgeInsets.only(
          bottom:16,
        ),




        padding:
        const EdgeInsets.all(18),




        decoration:
        BoxDecoration(


            color:
            Colors.white,



            borderRadius:
            BorderRadius.circular(25),




            boxShadow:[


              BoxShadow(

                color:
                Colors.black.withOpacity(.06),

                blurRadius:20,

                offset:
                const Offset(0,8),

              )

            ]


        ),





        child:
        Column(

          children:[



            Row(

              children:[



                Container(

                  width:55,

                  height:55,


                  decoration:
                  BoxDecoration(


                    gradient:
                    LinearGradient(

                      colors:

                      isLecture

                          ?

                      [
                        Colors.deepPurple,
                        Colors.purpleAccent
                      ]

                          :

                      [
                        Colors.green,
                        Colors.lightGreen
                      ],

                    ),


                    borderRadius:
                    BorderRadius.circular(18),

                  ),




                  child:
                  Icon(

                    isLecture

                        ?
                    Icons.school

                        :
                    Icons.home,


                    color:
                    Colors.white,

                    size:28,

                  ),



                ),





                const SizedBox(width:15),




                Expanded(

                  child:
                  Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[



                      Text(

                        item.student?.fullName ??
                            "Unknown",


                        style:
                        const TextStyle(

                          fontSize:18,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                      const SizedBox(height:4),




                      Text(

                        item.student?.studentIdentifier ??
                            "-",


                        style:
                        const TextStyle(

                          color:
                          Colors.grey,

                        ),

                      ),



                    ],

                  ),

                ),






                _statusBadge(),

              ],


            ),




            const SizedBox(height:18),




            Divider(
              color:
              Colors.grey.shade200,
            ),





            const SizedBox(height:12),





            _infoTile(

              Icons.school_outlined,

              "Academic",

              "Year ${item.student?.year ?? '-'} • ${item.student?.specialization ?? '-'}",

            ),




            _infoTile(

              isLecture

                  ?
              Icons.menu_book
                  :
              Icons.home,


              "Attendance Type",

              isLecture
                  ?
              "Lecture"
                  :
              "Housing",


            ),






            _infoTile(

              Icons.calendar_month,

              "Shift Date",

              "${item.shift?.day ?? '-'}\n${item.shift?.shiftDate ?? '-'}",

            ),






            _infoTile(

              Icons.access_time,

              "Time",

              "${item.shift?.fromHour ?? '-'} - ${item.shift?.toHour ?? '-'}",

            ),





            _infoTile(

              Icons.timer,

              "Recorded At",

              item.attendanceRecordedAt ?? "-",

            ),




          ],

        ),


      ),


    );



  }







  Widget _infoTile(

      IconData icon,

      String title,

      String value,

      ){


    return Container(


      margin:
      const EdgeInsets.only(
        bottom:10,
      ),


      padding:
      const EdgeInsets.all(12),



      decoration:
      BoxDecoration(


        color:
        const Color(0xffF7F8FC),


        borderRadius:
        BorderRadius.circular(15),

      ),




      child:
      Row(

        children:[


          Container(

            width:38,

            height:38,


            decoration:
            BoxDecoration(

              color:
              AppColors.primary.withOpacity(.12),

              borderRadius:
              BorderRadius.circular(12),

            ),



            child:
            Icon(

              icon,

              color:
              AppColors.primary,

              size:20,

            ),

          ),



          const SizedBox(width:12),




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

                    fontSize:12,

                    color:
                    Colors.grey,

                  ),

                ),




                const SizedBox(height:3),





                Text(

                  value,

                  style:
                  const TextStyle(

                    fontWeight:
                    FontWeight.w600,

                    fontSize:14,

                  ),

                ),



              ],


            ),

          ),



        ],


      ),



    );


  }

// ================= STATUS BADGE ===================


  Widget _statusBadge(){


    return Container(


      padding:
      const EdgeInsets.symmetric(

        horizontal:12,

        vertical:7,

      ),



      decoration:
      BoxDecoration(


        color:
        Colors.green.withOpacity(.12),


        borderRadius:
        BorderRadius.circular(30),


      ),




      child:
      const Row(

        mainAxisSize:
        MainAxisSize.min,


        children:[



          Icon(

            Icons.check_circle,

            size:16,

            color:
            Colors.green,

          ),



          SizedBox(width:5),




          Text(

            "Present",

            style:
            TextStyle(

              color:
              Colors.green,

              fontWeight:
              FontWeight.bold,

              fontSize:12,

            ),

          ),



        ],


      ),


    );



  }









// ================= STUDENT DETAILS ===================



  void _showStudentDetails(
      AttendanceHistoryModel item
      ){



    Get.bottomSheet(


      Container(


        padding:
        const EdgeInsets.all(25),



        decoration:
        const BoxDecoration(


          color:
          Colors.white,


          borderRadius:
          BorderRadius.vertical(

            top:
            Radius.circular(35),

          ),


        ),





        child:
        Column(


          mainAxisSize:
          MainAxisSize.min,



          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[





            Center(

              child:
              Container(

                width:45,

                height:5,


                decoration:
                BoxDecoration(

                  color:
                  Colors.grey.shade300,

                  borderRadius:
                  BorderRadius.circular(10),

                ),


              ),

            ),






            const SizedBox(height:20),





            Row(

              children:[


                CircleAvatar(

                  radius:30,


                  backgroundColor:
                  AppColors.primary.withOpacity(.12),


                  child:
                  const Icon(

                    Icons.person,

                    color:
                    AppColors.primary,

                    size:35,

                  ),


                ),




                const SizedBox(width:15),





                Expanded(

                  child:
                  Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[



                      Text(

                        item.student?.fullName ??
                            "-",


                        style:
                        const TextStyle(

                          fontSize:20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),





                      Text(

                        item.student?.studentIdentifier ??
                            "-",


                        style:
                        const TextStyle(

                          color:
                          Colors.grey,

                        ),

                      ),



                    ],


                  ),


                )



              ],


            ),





            const SizedBox(height:25),





            _detailRow(

              "Year",

              "${item.student?.year ?? '-'}",

            ),





            _detailRow(

              "Specialization",

              item.student?.specialization ?? "-",

            ),





            _detailRow(

              "Attendance Type",

              item.shiftType == "lecture"

                  ?
              "Lecture"

                  :
              "Housing",

            ),





            _detailRow(

              "Date",

              item.shift?.shiftDate ?? "-",

            ),





            _detailRow(

              "Day",

              item.shift?.day ?? "-",

            ),





            _detailRow(

              "Time",

              "${item.shift?.fromHour ?? '-'} - ${item.shift?.toHour ?? '-'}",

            ),





            _detailRow(

              "Recorded",

              item.attendanceRecordedAt ?? "-",

            ),





            const SizedBox(height:15),





            SizedBox(

              width:double.infinity,


              child:
              ElevatedButton(

                onPressed:(){

                  Get.back();

                },



                style:
                ElevatedButton.styleFrom(

                  padding:
                  const EdgeInsets.symmetric(
                    vertical:15,
                  ),


                  backgroundColor:
                  AppColors.primary,


                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),

                  ),

                ),



                child:
                const Text(

                  "Close",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



              ),


            ),





          ],

        ),



      ),



      isScrollControlled:true,

    );


  }









  Widget _detailRow(

      String title,

      String value,

      ){



    return Padding(


      padding:
      const EdgeInsets.only(
        bottom:12,
      ),



      child:
      Row(

        children:[


          Expanded(

            child:
            Text(

              title,

              style:
              const TextStyle(

                color:
                Colors.grey,

                fontSize:14,

              ),

            ),


          ),




          Text(

            value,

            style:
            const TextStyle(

              fontWeight:
              FontWeight.w600,

            ),

          ),



        ],


      ),


    );



  }
}