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
import 'package:supervisors/widgets/StudentRecordSection.dart';

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

          ///// WARNINGS
          StudentRecordSection(

            title:"warnings".tr,

            icon:
            Icons.warning_amber_rounded,

            color:
            Colors.orange,


            children:

            warningsController.warnings.map(

                    (warning)=>

                    _historyCard(

                      context: context,

                      icon:Icons.warning,

                      color:Colors.orange,

                      title:warning.title,

                      subtitle:warning.description,

                      date:
                      warning.warningDate
                          .split('T')
                          .first,


                      onTap:(){

                        Get.to(
                              ()=>WarningDetailsView(),
                          arguments:
                          warning.id,
                        );

                      },


                      onEdit:(){

                        Get.to(
                              ()=>EditWarningView(
                            warning: warning,
                          ),
                        );

                      },


                      onDelete:(){

                        warningsController
                            .deleteWarning(
                            warning.id
                        );

                      },


                    )

            ).toList(),


          ),
          const SizedBox(height: 20),

          ///// VIOLATIONS

          StudentRecordSection(

            title:
            "violations".tr,

            icon:
            Icons.block,

            color:
            Colors.red,


            children:

            violationsController.violations.map(

                    (violation)=>

                    _historyCard(

                      context: context,

                      icon:
                      Icons.block,

                      color:
                      Colors.red,


                      title:
                      violation.title,


                      subtitle:
                      violation.description,


                      date:
                      violation.violationDate
                          .split('T')
                          .first,


                      onTap:(){

                        Get.to(

                              ()=>ViolationDetailsView(),

                          arguments:
                          violation.id,

                        );

                      },


                      onEdit:(){

                        Get.to(

                              ()=>EditViolationView(

                            violation:
                            violation,

                          ),

                        );

                      },



                      onDelete:(){

                        violationsController
                            .deleteViolation(
                            violation.id
                        );

                      },



                    )

            ).toList(),


          ),
          const SizedBox(height: 20),

          ///// REWARDS

          StudentRecordSection(

            title:
            "rewards".tr,


            icon:
            Icons.star,


            color:
            Colors.green,



            children:

            rewardsController.rewards.map(

                    (reward)=>


                    _historyCard(


                      context: context,


                      icon:
                      Icons.star,


                      color:
                      Colors.green,


                      title:
                      reward.title,


                      subtitle:
                      reward.description,


                      date:
                      reward.createdAt
                          .split('T')
                          .first,



                      onTap:(){

                        Get.to(

                              ()=>RewardDetailsView(),

                          arguments:
                          reward.id,

                        );

                      },



                      onEdit:(){


                        Get.to(

                              ()=>EditRewardView(

                            reward:
                            reward,

                          ),

                        );

                      },



                      onDelete:(){


                        rewardsController
                            .deleteReward(
                            reward.id
                        );


                      },


                    )


            ).toList(),


          ),
          const SizedBox(height: 20),

          //// REPORTS

          StudentRecordSection(

          title:
          "reports".tr,


          icon:
          Icons.article,


          color:
          Colors.blue,



          children:

          reportsController.reports.map(


          (report)=>


          _historyCard(


          context: context,


          icon:
          Icons.article,


          color:
          Colors.blue,


          title:
          "report".tr,


          subtitle:
          report.notes,


          date:
          report.createdAt
              .split('T')
              .first,



          onTap:(){


          Get.to(

          ()=>ReportDetailsView(),

          arguments:
          report.id,

          );


          },



      onEdit:(){


      Get.to(

      ()=>EditReportView(

      report:
      report,

      ),

      );


      },



      onDelete:(){


      reportsController
          .deleteReport(
      report.id
      );


      },



      )


      ).toList(),




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
    required BuildContext context,
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

          color: Theme.of(context).cardColor,

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
                      color:Theme.of(context).textTheme.bodySmall?.color,
                      fontSize:12,
                    ),
                  ),


                ],
              ),
            ),
            PopupMenuButton(


              itemBuilder:(context)=>[


                PopupMenuItem(

                  value:"edit",

                  child:Row(

                    children:[

                      const Icon(Icons.edit),

                      const SizedBox(width:8),

                      Text("edit".tr),

                    ],

                  ),

                ),



                PopupMenuItem(

                  value:"delete",

                  child:Row(

                    children:[

                      const Icon(Icons.delete,color:Colors.red),

                      const SizedBox(width:8),

                      Text("delete".tr),

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
          ],

        ),

      ),
    );

  }}




