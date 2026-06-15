import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisors/view/EditReportView.dart';
import 'package:supervisors/view/EditRewardView.dart';
import 'package:supervisors/view/EditViolationView.dart';
import 'package:supervisors/view/EditWarningView.dart';
import 'package:supervisors/view/ReportDetailsView.dart';
import 'package:supervisors/view/RewardDetailsView.dart';
import 'package:supervisors/view/ViolationDetailsView.dart';
import 'package:supervisors/view/WarningDetailsView.dart';

import '../controller/warning_controller.dart';
import '../controller/ViolationsController.dart';
import '../controller/RewardsController.dart';
import '../controller/ReportsController.dart';

class StudentHistoryTab extends StatelessWidget {
  const StudentHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {

    final warningsController =
    Get.find<WarningsController>();

    final violationsController =
    Get.find<ViolationsController>();

    final rewardsController =
    Get.find<RewardsController>();

    final reportsController =
    Get.find<ReportsController>();

    return Obx(() {

      return ListView(

        padding:
        const EdgeInsets.all(16),

        children: [

          /// WARNINGS
          _sectionTitle(
            "التحذيرات",
            Icons.warning_amber_rounded,
            Colors.orange,
          ),

          // ...warningsController.warnings.map(
          //       (warning) => _historyCard(
          //         icon: Icons.warning,
          //         color: Colors.orange,
          //         title: warning.title,
          //         subtitle: warning.description,
          //         date: warning.warningDate
          //             .split('T')
          //             .first,
          //
          //         onTap: () {
          //
          //           Get.to(
          //                 ()=>WarningDetailsView(),
          //             arguments: warning.id,
          //           );
          //
          //         },
          //
          //
          //         onDelete: (){
          //
          //           warningsController.deleteWarning(
          //             warning.id,
          //           );
          //
          //         },
          //
          //
          //         onEdit: (){
          //
          //           print(
          //               "تعديل التحذير ${warning.id}"
          //           );
          //
          //         },
          //       ),
          // ),

          ...warningsController.warnings.map(

                (warning)=>_historyCard(

              icon: Icons.warning,

              color: Colors.orange,


              title:
              warning.title,


              subtitle:
              warning.description,


              date:
              warning.warningDate
                  .split('T')
                  .first,


              onTap: (){

                Get.to(
                      ()=>WarningDetailsView(),

                  arguments:
                  warning.id,

                );

              },


                  onEdit: () async {


                    final result = await Get.to(

                          ()=>EditWarningView(

                        warning: warning,

                      ),

                    );



                    if(result == true){

                      warningsController
                          .getStudentWarnings(
                        warning.id,
                      );

                    }


                  },


              onDelete: (){

                warningsController.deleteWarning(
                    warning.id
                );

              },


            ),

          ),

          const SizedBox(height: 20),

          /// VIOLATIONS
          _sectionTitle(
            "المخالفات",
            Icons.block,
            Colors.red,
          ),

          ...violationsController
              .violations
              .map(
                (violation) => _historyCard(
                  icon: Icons.block,
                  color: Colors.red,

                  title: violation.title,

                  subtitle:
                  violation.description,

                  date: violation
                      .violationDate
                      .split('T')
                      .first,

                  onTap: () {

                    Get.to(
                          () => ViolationDetailsView(),
                      arguments:
                      violation.id,
                    );
                  },

                  onDelete: (){

                    violationsController.deleteViolation(
                      violation.id,
                    );

                  },


                  onEdit: (){
                    Get.to(
                          () => EditViolationView(
                        violation: violation,
                      ),
                    );

                  },
                ),
          ),

          const SizedBox(height: 20),

          /// REWARDS
          _sectionTitle(
            "المكافآت",
            Icons.star,
            Colors.green,
          ),

          ...rewardsController.rewards.map(
                (reward) => _historyCard(
                  icon: Icons.star,
                  color: Colors.green,

                  title: reward.title,

                  subtitle:
                  reward.description,

                  date: reward.createdAt
                      .split('T')
                      .first,

                  onTap: () {

                    Get.to(
                          () => RewardDetailsView(),
                      arguments:
                      reward.id,
                    );
                  },

                  onDelete: (){

                    rewardsController.deleteReward(
                      reward.id,
                    );

                  },


                  onEdit: (){

                    Get.to(

                          ()=>EditRewardView(

                        reward: reward,

                      ),


                    );

                  },
                ),
          ),

          const SizedBox(height: 20),

          /// REPORTS
          _sectionTitle(
            "التقارير",
            Icons.article,
            Colors.blue,
          ),

          ...reportsController.reports.map(
                (report) => _historyCard(
                  icon: Icons.article,
                  color: Colors.blue,

                  title: "تقرير",

                  subtitle: report.notes,

                  date: report.createdAt
                      .split('T')
                      .first,

                  onTap: () {

                    Get.to(
                          () => ReportDetailsView(),
                      arguments:
                      report.id,
                    );
                  },

                  onDelete: (){

                    reportsController.deleteReport(
                      report.id,
                    );

                  },


                  onEdit: (){
                    Get.to(

                          ()=>EditReportView(

                        report: report,

                      ),

                    );

                  },
                ),
          ),
        ],
      );
    });
  }

  Widget _sectionTitle(
      String title,
      IconData icon,
      Color color,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [

          Icon(
            icon,
            color: color,
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style:
            const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget _historyCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String date,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,

  }) {

    return InkWell(

      borderRadius: BorderRadius.circular(20),

      onTap: onTap,

      child: Container(

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          boxShadow: [

            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0,4),
            )

          ],

        ),


        child: Row(

          children: [


            Container(

              width: 50,
              height: 50,

              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                shape: BoxShape.circle,
              ),

            //   child: Icon(
            //     icon,
            //     color: color,
            //   ),
            // ),
                child:  Icon(
                  Icons.arrow_forward_ios_rounded,
                  size:18,
                ),
            ),
            const SizedBox(width:14),


            Expanded(

              child: Column(

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


                  const SizedBox(height:6),


                  Text(
                    subtitle,
                    maxLines:2,
                    overflow:
                    TextOverflow.ellipsis,
                  ),


                  const SizedBox(height:8),


                  Text(
                    date,
                    style:
                    TextStyle(
                      color:Colors.grey[500],
                      fontSize:12,
                    ),
                  ),


                ],
              ),
            ),
            PopupMenuButton(


              itemBuilder:(context)=>[


                const PopupMenuItem(

                  value:"edit",

                  child:Row(

                    children:[

                      Icon(Icons.edit),

                      SizedBox(width:8),

                      Text("تعديل"),

                    ],

                  ),

                ),



                const PopupMenuItem(

                  value:"delete",

                  child:Row(

                    children:[

                      Icon(Icons.delete,color:Colors.red),

                      SizedBox(width:8),

                      Text("حذف"),

                    ],

                  ),

                ),



              ],


              onSelected:(value){


                if(value=="edit"){

                  onEdit();

                }


                if(value=="delete"){

                  onDelete();

                }


              },

            )

            //
            // PopupMenuButton(
            //
            //   itemBuilder: (context)=>[
            //
            //
            //     PopupMenuItem(
            //
            //       child:
            //       const Row(
            //
            //         children:[
            //
            //           Icon(
            //             Icons.edit,
            //             color:Colors.blue,
            //           ),
            //
            //           SizedBox(width:8),
            //
            //           Text("تعديل")
            //
            //         ],
            //       ),
            //
            //
            //       onTap: (){
            //
            //         Future.delayed(
            //             Duration.zero,
            //                 (){
            //               onEdit?.call();
            //             }
            //         );
            //
            //       },
            //
            //     ),
            //
            //
            //
            //     PopupMenuItem(
            //
            //       child:
            //       const Row(
            //
            //         children:[
            //
            //           Icon(
            //             Icons.delete,
            //             color:Colors.red,
            //           ),
            //
            //           SizedBox(width:8),
            //
            //           Text("حذف")
            //
            //         ],
            //       ),
            //
            //
            //       onTap: (){
            //
            //         Future.delayed(
            //             Duration.zero,
            //                 (){
            //               onDelete?.call();
            //             }
            //         );
            //
            //       },
            //
            //     ),
            //
            //
            //   ],
            // )

          ],

        ),

      ),
    );

  }}




